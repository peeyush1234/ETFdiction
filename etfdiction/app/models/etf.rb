class Etf
  extend Memoist

  ETF_3X_BULL = {name: "etf_3x_bull", values: ['BAR',	'BRZU',	'BUNT',	'CURE',	'DRN',	'DZK',	'EDC',	'ERX',	'EURL',	'FAS',	'FINU',	'GASL',	'INDL',	'JDST',	'JGBT',	'JNUG',	'JPNL',	'LBJ',	'MATL',	'MIDU',	'NUGT',	'RETL',	'RUSL',	'SOXL',	'SPXL',	'TECL',	'TMF',	'TNA',	'TQQQ',	'TYD',	'UDOW',	'UGAZ',	'UGLD',	'UMDD',	'UPRO',	'URTY',	'USLV',	'UWTI',	'YINN']}.freeze

  ETF_3X_BEAR = {name: "etf_3x_bear", values: ['DGAZ',	'DGLD',	'DPK',	'DRV',	'DSLV',	'DUST',	'DWTI',	'EDZ',	'ERY',	'FAZ',	'FINZ',	'JGBD',	'LBND',	'MIDZ',	'RUSS',	'SBND',	'SDOW',	'SMDD',	'SOXS',	'SPXS',	'SPXU',	'SQQQ',	'SRTY',	'TECS',	'TMV',	'TTT',	'TYO',	'TZA',	'YANG']}.freeze

  ETF_2X_BULL = {name: "etf_2x_bull", values: ['AGQ',	'BDCL',	'BDD',	'BIB',	'BOIL',	'CEFL',	'DAG',	'DDM',	'DGP',	'DIG',	'DVHL',	'DVYL',	'DYY',	'EET',	'EFO',	'EZJ',	'GDAY',	'IGU',	'KRU',	'LMLP',	'LTL',	'MLPL',	'MORL',	'MVV',	'QLD',	'ROM',	'RWXL',	'RXL',	'SAA',	'SDYL',	'SMHD',	'SPLX',	'SSO',	'THHY',	'TVIX',	'UBR',	'UBT',	'UCC',	'UCD',	'UCO',	'UGE',	'UGL',	'UJB',	'ULE',	'UMX',	'UPV',	'UPW',	'URE',	'URR',	'USD',	'UST',	'UVXY',	'UWM',	'UXI',	'UXJ',	'UYG',	'UYM',	'XPP',	'YCL']}.freeze

  ETF_2X_BEAR = {name: "etf_2x_bear", values: ['AGA',	'BIS',	'BOM',	'BZQ',	'CMD',	'CROC',	'DEE',	'DGZ',	'DRR',	'DTO',	'DUG',	'DXD',	'DZZ',	'EEV',	'EFU',	'EPV',	'EUO',	'EWV',	'FXP',	'GLL',	'KOLD',	'MZZ',	'PST',	'QID',	'REW',	'RXD',	'SCC',	'SCIN',	'SCO',	'SDD',	'SDP',	'SDS',	'SIJ',	'SKF',	'SMK',	'SMN',	'SRS',	'SSG',	'SZK',	'TBT',	'TBZ',	'TLL',	'TPS',	'TWM',	'YCS',	'ZSL']}.freeze

  ETF_BULL = {name: "etf_bull", values: ['RSX', 'EWZ', 'INDA', 'EWJ', 'EWY', 'IEV', 'MCHI']}

  attr_accessor :name

  def initialize(name)
    self.name = name
  end

  def self.all
    ETF_BULL[:values].map{|etf_name| self.new(etf_name)}
  end

  def realtime_from_yahoo
    url = "http://finance.yahoo.com/q?d=t&s=#{name}"
    page = Nokogiri::HTML(Manticore.get(url).body)
    current = page.css('.time_rtq_ticker').children.children.first.text.to_f
    open = page.css('#table1').css(".yfnc_tabledata1")[1].children.first.text.to_f
    low, high = page.css('#table2').css(".yfnc_tabledata1")[0].children.text.split('-').map(&:to_f)
    {current: current, open: open, low: low, high: high}
  end

  memoize :realtime_from_yahoo

  def self.day_3_high_low_etfs
    all.select {|etf| etf.day_3_high_low?}
  end

  # Chapter 2
  def day_3_high_low?
    return false unless price_above_sma?(200)

    if market_opened?
      etf_prices = EtfPrice.where(name: name).where("date < '#{Date.today}'").order(date: :desc).limit(3).reverse
      current = realtime_from_yahoo
      return true if (
        (etf_prices[1].high < etf_prices[0].high) &&
        (etf_prices[2].high < etf_prices[1].high) &&
        (etf_prices[1].low < etf_prices[0].low) &&
        (etf_prices[2].low < etf_prices[1].low) &&
        (current[:low] < etf_prices[2].low) &&
        (current[:high] < etf_prices[2].high)
      )
    else
      etf_prices = EtfPrice.where(name: name).where("date <= '#{Date.today}'").order(date: :desc).limit(3).reverse
      return true if (
      (etf_prices[1].high < etf_prices[0].high) &&
        (etf_prices[2].high < etf_prices[1].high) &&
        (etf_prices[1].low < etf_prices[0].low) &&
        (etf_prices[2].low < etf_prices[1].low)
      )
      end

    false
  end

  # Chapter 3
  def rsi_25?
    return false unless price_above_sma?(200)

    return true if current_rsi(4) < 25

    return false
  end

  # Chapter 4
  def r_3?
    return false unless price_above_sma?(200)

    today = Date.today

    past_rsi_2_period = rsi(2, today - 2.days)

    return true if ( past_rsi_2_period < 60 &&
                     rsi(2, today - 1.days) < past_rsi_2_period &&
                     current_rsi(2) < 10)

    false
  end

  def current_sma(period)
    records_close = get_latest_records(:close, period)
    return nil if records_close.count < period

    compute_sma(records_close)
  end

  def sma(period, date)
    records_close = EtfPrice.where(name: name).where("date <= '#{date}'").order(date: :desc).limit(period).pluck(:close)
    return nil if records_close.count < period

    compute_sma(records_close)
  end

  def current_rsi(period)
    records_close = get_latest_records(:close, period + 1)
    return nil if records_close.count < period + 1

    compute_rsi(records_close)
  end

  def rsi(period, date)
    records_close = EtfPrice.where(name: name).where("date <= '#{date}'").order(date: :desc).limit(period+1).pluck(:close)
    return nil if records_close.count < period + 1

    compute_rsi(records_close)
  end

  # Last three prices should be above given sma
  def price_above_sma?(period)
    records_close = get_latest_records(:close, 3)
    sma_for_period = current_sma(period)

    return records_close.all? {|close| close > sma_for_period}
  end

  private

  def get_latest_records(metric, count)
    if market_opened?
      records_close = EtfPrice.where(name: name).where("date <= '#{Date.today-1}'").order(date: :desc).limit(count - 1).pluck(metric)
      records_close.unshift(realtime_from_yahoo[:current])
    else
      records_close = EtfPrice.where(name: name).where("date <= '#{Date.today-1}'").order(date: :desc).limit(count).pluck(metric)
    end

    records_close
  end

  def compute_rsi(close_prices)
    period = close_prices.count - 1
    data_setup = Indicators::Data.new(close_prices.reverse)
    data_setup.calc(type: :rsi, params: period).output.last.round(2)
  end

  def compute_sma(close_prices)
    period = close_prices.count
    (close_prices.sum/period.to_f).to_f.round(2)
  end

  def market_opened?
    t = Time.now

    return false if t.sunday? || t.saturday?

    # UTC
    Range.new(
      Time.local(t.year, t.month, t.day, 14, 30).to_i,
      Time.local(t.year, t.month, t.day, 21).to_i
    ) === t.to_i
  end
end