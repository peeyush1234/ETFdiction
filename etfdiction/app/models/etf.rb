class Etf

  ETF_3X_BULL = {name: "etf_3x_bull", values: ['BAR',	'BRZU',	'BUNT',	'CURE',	'DRN',	'DZK',	'EDC',	'ERX',	'EURL',	'FAS',	'FINU',	'GASL',	'INDL',	'JDST',	'JGBT',	'JNUG',	'JPNL',	'LBJ',	'MATL',	'MIDU',	'NUGT',	'RETL',	'RUSL',	'SOXL',	'SPXL',	'TECL',	'TMF',	'TNA',	'TQQQ',	'TYD',	'UDOW',	'UGAZ',	'UGLD',	'UMDD',	'UPRO',	'URTY',	'USLV',	'UWTI',	'YINN']}.freeze

  ETF_3X_BEAR = {name: "etf_3x_bear", values: ['DGAZ',	'DGLD',	'DPK',	'DRV',	'DSLV',	'DUST',	'DWTI',	'EDZ',	'ERY',	'FAZ',	'FINZ',	'JGBD',	'LBND',	'MIDZ',	'RUSS',	'SBND',	'SDOW',	'SMDD',	'SOXS',	'SPXS',	'SPXU',	'SQQQ',	'SRTY',	'TECS',	'TMV',	'TTT',	'TYO',	'TZA',	'YANG']}.freeze

  ETF_2X_BULL = {name: "etf_2x_bull", values: ['AGQ',	'BDCL',	'BDD',	'BIB',	'BOIL',	'CEFL',	'DAG',	'DDM',	'DGP',	'DIG',	'DVHL',	'DVYL',	'DYY',	'EET',	'EFO',	'EZJ',	'GDAY',	'IGU',	'KRU',	'LMLP',	'LTL',	'MLPL',	'MORL',	'MVV',	'QLD',	'ROM',	'RWXL',	'RXL',	'SAA',	'SDYL',	'SMHD',	'SPLX',	'SSO',	'THHY',	'TVIX',	'UBR',	'UBT',	'UCC',	'UCD',	'UCO',	'UGE',	'UGL',	'UJB',	'ULE',	'UMX',	'UPV',	'UPW',	'URE',	'URR',	'USD',	'UST',	'UVXY',	'UWM',	'UXI',	'UXJ',	'UYG',	'UYM',	'XPP',	'YCL']}.freeze

  ETF_2X_BEAR = {name: "etf_2x_bear", values: ['AGA',	'BIS',	'BOM',	'BZQ',	'CMD',	'CROC',	'DEE',	'DGZ',	'DRR',	'DTO',	'DUG',	'DXD',	'DZZ',	'EEV',	'EFU',	'EPV',	'EUO',	'EWV',	'FXP',	'GLL',	'KOLD',	'MZZ',	'PST',	'QID',	'REW',	'RXD',	'SCC',	'SCIN',	'SCO',	'SDD',	'SDP',	'SDS',	'SIJ',	'SKF',	'SMK',	'SMN',	'SRS',	'SSG',	'SZK',	'TBT',	'TBZ',	'TLL',	'TPS',	'TWM',	'YCS',	'ZSL']}.freeze

  ETF_BULL = {name: "etf_bull", values: ['RSX', 'EWZ', 'INDA', 'EWJ', 'EWY', 'IEV', 'MCHI']}

  attr_accessor :name

  def initialize(name)
    self.name = name
  end

  def current_sma(period)
    records_close = get_records_close(period)
    return nil if records_close.count < period

    compute_sma(records_close)
  end

  def sma(period, date)
    records_close = EtfPrice.where(name: name).where("date <= '#{date}'").order(date: :desc).limit(period).pluck(:close)
    return nil if records_close.count < period

    compute_sma(records_close)
  end

  def current_rsi(period)
    records_close = get_records_close(period + 1)
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
    records_close = get_records_close(3)
    sma_for_period = current_sma(period)

    return records_close.all? {|close| close > sma_for_period}
  end

  def current_info
    DataFetcher.realtime_price(name)
  end

  private

  def get_records_close(count)
    if market_opened?
      records_close = EtfPrice.where(name: name).where("date <= '#{Date.today-1}'").order(date: :desc).limit(count - 1).pluck(:close)
      records_close.unshift(current_info[:price])
    else
      records_close = EtfPrice.where(name: name).where("date <= '#{Date.today-1}'").order(date: :desc).limit(count).pluck(:close)
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

    # UTC
    Range.new(
      Time.local(t.year, t.month, t.day, 14, 30).to_i,
      Time.local(t.year, t.month, t.day, 21).to_i
    ) === t.to_i
  end
end