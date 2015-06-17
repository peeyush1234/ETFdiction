class Etf
  extend Memoist

  ETF_3X_BULL = {name: "etf_3x_bull", values: ['BAR',	'BRZU',	'BUNT',	'CURE',	'DRN',	'DZK',	'EDC',	'ERX',	'EURL',	'FAS',	'FINU',	'GASL',	'INDL',	'JDST',	'JGBT',	'JNUG',	'JPNL',	'LBJ',	'MATL',	'MIDU',	'NUGT',	'RETL',	'RUSL',	'SOXL',	'SPXL',	'TECL',	'TMF',	'TNA',	'TQQQ',	'TYD',	'UDOW',	'UGAZ',	'UGLD',	'UMDD',	'UPRO',	'URTY',	'USLV',	'UWTI',	'YINN']}.freeze

  ETF_3X_BEAR = {name: "etf_3x_bear", values: ['DGAZ',	'DGLD',	'DPK',	'DRV',	'DSLV',	'DUST',	'DWTI',	'EDZ',	'ERY',	'FAZ',	'FINZ',	'JGBD',	'LBND',	'MIDZ',	'RUSS',	'SBND',	'SDOW',	'SMDD',	'SOXS',	'SPXS',	'SPXU',	'SQQQ',	'SRTY',	'TECS',	'TMV',	'TTT',	'TYO',	'TZA',	'YANG']}.freeze

  ETF_2X_BULL = {name: "etf_2x_bull", values: ['AGQ',	'BDCL',	'BDD',	'BIB',	'BOIL',	'CEFL',	'DAG',	'DDM',	'DGP',	'DIG',	'DVHL',	'DVYL',	'DYY',	'EET',	'EFO',	'EZJ',	'GDAY',	'IGU',	'KRU',	'LMLP',	'LTL',	'MLPL',	'MORL',	'MVV',	'QLD',	'ROM',	'RWXL',	'RXL',	'SAA',	'SDYL',	'SMHD',	'SPLX',	'SSO',	'THHY',	'TVIX',	'UBR',	'UBT',	'UCC',	'UCD',	'UCO',	'UGE',	'UGL',	'UJB',	'ULE',	'UMX',	'UPV',	'UPW',	'URE',	'URR',	'USD',	'UST',	'UVXY',	'UWM',	'UXI',	'UXJ',	'UYG',	'UYM',	'XPP',	'YCL']}.freeze

  ETF_2X_BEAR = {name: "etf_2x_bear", values: ['AGA',	'BIS',	'BOM',	'BZQ',	'CMD',	'CROC',	'DEE',	'DGZ',	'DRR',	'DTO',	'DUG',	'DXD',	'DZZ',	'EEV',	'EFU',	'EPV',	'EUO',	'EWV',	'FXP',	'GLL',	'KOLD',	'MZZ',	'PST',	'QID',	'REW',	'RXD',	'SCC',	'SCIN',	'SCO',	'SDD',	'SDP',	'SDS',	'SIJ',	'SKF',	'SMK',	'SMN',	'SRS',	'SSG',	'SZK',	'TBT',	'TBZ',	'TLL',	'TPS',	'TWM',	'YCS',	'ZSL']}.freeze

  ETF_BULL = {name: "etf_bull", values: ['GLD', 'UNG', 'RSX', 'EWZ', 'INDA', 'EWJ', 'EWY', 'IEV', 'MCHI']}

  STRATEGIES_LIST = [:DHL, :R25, :RS3, :BBP, :MUD, :R10, :TPS]

  # Display name and method name should be unique
  A200_ETF_STRATEGIES = [
    {method_name: :a200_day_3_high_low?, strategy_name: :DHL, description: [
      "1. Today ETF closes below 5 SMA.",
      "2. Two days ago the high and low is below the previous day's.",
      "3. Yesterday the high and low is below the previous day's.",
      "4. Buy on the close.",
      "5. AV: Buy more of goes down.",
      "6. Exit on the close when price above 5 SMA."
    ]},
    {method_name: :a200_rsi_25?, strategy_name: :R25, description: [
      "1. RSI(4) closes under 25. Buy on close.",
      "2. AV: Buy more if RSI(4) goes below 20.",
      "3. Exit when RSI(4) above 55."
    ]},
    {method_name: :a200_r_3?, strategy_name: :RS3, description: [
      "1. RSI(2) drops 3 days in a row. The first day's drop is below 60.",
      "2. RSI(2) closes under 10 today. Buy on close.",
      "3. AV: Buy more if price lower then entry.",
      "4. Exit when RSI(2) above 70."
    ]},
    {method_name: :a200_bb?, strategy_name: :BBP, description: [
      "1. %b is under 0.2 for 3 days in a row. Buy on third day close.",
      "2. AV: Buy more if %b close below 0.2 again.",
      "3. Exist when %b above 0.8."
    ]},
    {method_name: :a200_multiple_day_up_down?, strategy_name: :MUD, description: [
      "1. ETF closes below 5 SMA on entry day",
      "2. Must drop 4 out of 5 days. If happens buy on the close.",
      "3. AV: Buy more if price lower then entry.",
      "4. Exit when cose above 5 SMA."
    ]},
    {method_name: :a200_rsi_10_6?, strategy_name: :R10, description: [
      "1. Buy if RSI(2) goes under 10.",
      "2. Buy more if RSI(2) under 6.",
      "3. Exit when close amove 5 SMA."
    ]},
    {method_name: :a200_rsi_25_2?, strategy_name: :TPS, description: [
      "1. RSI(2) below 25 for 2 days in row. Buy 10% at close.",
      "2. If prices are lower than previous entry, buy 20% more.",
      "3. If prices goes lower again, buy 30% more",
      "4. If prices goes lower again, buy 40% more",
      "5. Exit when RSI(2) above 70"
    ]}
  ]

  # Display name and method name should be unique
  B200_ETF_STRATEGIES = [
    {method_name: :b200_day_3_high_low?, strategy_name: :DHL, description: [
      "Testing"
    ]},
    {method_name: :b200_rsi_25?, strategy_name: :R25, description: [
      "Testing"
    ]},
    {method_name: :b200_r_3?, strategy_name: :RS3, description: [
      "Testing"
    ]},
    {method_name: :b200_bb?, strategy_name: :BBP, description: [
      "Testing"
    ]},
    {method_name: :b200_multiple_day_up_down?, strategy_name: :MUD, description: [
      "Testing"
    ]},
    {method_name: :b200_rsi_10_6?, strategy_name: :R10, description: [
      "Testing"
    ]},
    {method_name: :b200_rsi_25_2?, strategy_name: :TPS, description: [
      "Testing"
    ]}
  ]

  attr_accessor :name

  def initialize(name)
    self.name = name
  end

  def a200_strategies_result
    A200_ETF_STRATEGIES.map do |i|
      {strategy_name: i[:strategy_name], result: self.send(i[:method_name]) ? 1 : 0}
    end
  end

  def b200_strategies_result
    B200_ETF_STRATEGIES.map do |i|
      {strategy_name: i[:strategy_name], result: self.send(i[:method_name]) ? 1 : 0}
    end
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

  # Chapter 8A
  def a200_rsi_25_2?
    records_close = EtfPrice.where(name: name).where("date <= '#{Date.today}'").order(date: :desc).limit(3).pluck(:close)
    past_rsi = compute_rsi(records_close)

    return false if past_rsi > 25
    if market_opened?
      return true if current_rsi(2) <= 25
    else
      return true
    end

    false
  end

  # Chapter 8B
  def b200_rsi_25_2?
    records_close = EtfPrice.where(name: name).where("date <= '#{Date.today}'").order(date: :desc).limit(3).pluck(:close)
    past_rsi = compute_rsi(records_close)

    return false if past_rsi < 75
    if market_opened?
      return true if current_rsi(2) >= 75
    else
      return true
    end

    false
  end

  # Chapter 7A
  def a200_rsi_10_6?
    return true if current_rsi(2) <= 10

    false
  end

  # Chapter 7B
  def b200_rsi_10_6?
    return true if current_rsi(2) >= 90

    false
  end

  # Chapter 6A
  # TODO: Add 5 day sma condition too
  def a200_multiple_day_up_down?
    records_close = EtfPrice.where(name: name).where("date <= '#{Date.today}'").order(date: :desc).limit(5).pluck(:close)
    count = 0
    count += 1 if records_close[0] < records_close[1]
    count += 1 if records_close[1] < records_close[2]
    count += 1 if records_close[2] < records_close[3]
    count += 1 if records_close[3] < records_close[4]
    if market_opened?
      current_price = realtime_from_yahoo[:current]
      count += 1 if current_price < records_close[0]
      return true if count >= 4
    else
      return true if count >= 3
    end

    false
  end

  # Chapter 6B
  # TODO: Add 5 day sma condition too
  def b200_multiple_day_up_down?
    records_close = EtfPrice.where(name: name).where("date <= '#{Date.today}'").order(date: :desc).limit(5).pluck(:close)
    count = 0
    count += 1 if records_close[0] > records_close[1]
    count += 1 if records_close[1] > records_close[2]
    count += 1 if records_close[2] > records_close[3]
    count += 1 if records_close[3] > records_close[4]
    if market_opened?
      current_price = realtime_from_yahoo[:current]
      count += 1 if current_price > records_close[0]
      return true if count >= 4
    else
      return true if count >= 3
    end

    false
  end

  #chapter 5A
  def a200_bb?
    records_close = EtfPrice.where(name: name).where("date <= '#{Date.today}'").order(date: :desc).limit(5).pluck(:close)
    bb_1 = compute_bb(records_close[1..-1])
    bb_2 = compute_bb(records_close[0..-1])
    if market_opened?
      current_bb = compute_bb([realtime_from_yahoo[:current]].concat(records_close))
      return true if (bb_1 <= 0.2 && bb_2 <= 0.2 && current_bb <= 0.2)
    else
      return true if (bb_1 <= 0.2 && bb_2 <= 0.2)
    end

    false
  end

  def b200_bb?
    records_close = EtfPrice.where(name: name).where("date <= '#{Date.today}'").order(date: :desc).limit(5).pluck(:close)
    bb_1 = compute_bb(records_close[1..-1])
    bb_2 = compute_bb(records_close[0..-1])
    if market_opened?
      current_bb = compute_bb([realtime_from_yahoo[:current]].concat(records_close))
      return true if (bb_1 >= 0.8 && bb_2 >= 0.8 && current_bb >= 0.8)
    else
      return true if (bb_1 >= 0.8 && bb_2 >= 0.8)
    end

    false
  end

  # Chapter 2A
  def a200_day_3_high_low?
    if market_opened?
      etf_prices = EtfPrice.where(name: name).where("date < '#{Date.today}'").order(date: :desc).limit(3).reverse
      current = realtime_from_yahoo
      return true if (
        (etf_prices[1].high <= etf_prices[0].high) &&
        (etf_prices[2].high <= etf_prices[1].high) &&
        (etf_prices[1].low <= etf_prices[0].low) &&
        (etf_prices[2].low <= etf_prices[1].low) &&
        (current[:low] <= etf_prices[2].low) &&
        (current[:high] <= etf_prices[2].high)
      )
    else
      etf_prices = EtfPrice.where(name: name).where("date <= '#{Date.today}'").order(date: :desc).limit(3).reverse
      return true if (
      (etf_prices[1].high <= etf_prices[0].high) &&
        (etf_prices[2].high <= etf_prices[1].high) &&
        (etf_prices[1].low <= etf_prices[0].low) &&
        (etf_prices[2].low <= etf_prices[1].low)
      )
      end

    false
  end

  # TODO: Chapter 2B
  def b200_day_3_high_low?
    if market_opened?
      etf_prices = EtfPrice.where(name: name).where("date < '#{Date.today}'").order(date: :desc).limit(3).reverse
      current = realtime_from_yahoo
      return true if (
      (etf_prices[1].high >= etf_prices[0].high) &&
        (etf_prices[2].high >= etf_prices[1].high) &&
        (etf_prices[1].low >= etf_prices[0].low) &&
        (etf_prices[2].low >= etf_prices[1].low) &&
        (current[:low] >= etf_prices[2].low) &&
        (current[:high] >= etf_prices[2].high)
      )
    else
      etf_prices = EtfPrice.where(name: name).where("date <= '#{Date.today}'").order(date: :desc).limit(3).reverse
      return true if (
      (etf_prices[1].high >= etf_prices[0].high) &&
        (etf_prices[2].high >= etf_prices[1].high) &&
        (etf_prices[1].low >= etf_prices[0].low) &&
        (etf_prices[2].low >= etf_prices[1].low)
      )
    end

    false
  end

  # Chapter 3A
  def a200_rsi_25?
    return true if current_rsi(4) <= 25

    return false
  end

  # Chapter 3B
  def b200_rsi_25?
    return true if current_rsi(4) >= 75

    return false
  end

  # Chapter 4A
  def a200_r_3?
    today = Date.today

    records_close = EtfPrice.where(name: name).where("date <= '#{today}'").order(date: :desc).limit(5).pluck(:close)

    past_first_rsi_2_period = compute_rsi(records_close[1..3])
    past_second_rsi_2_period = compute_rsi(records_close[0..2])

    if market_opened?
        return true if ( past_first_rsi_2_period <= 60 &&
                     past_second_rsi_2_period <= past_first_rsi_2_period &&
                     current_rsi(2) <= 10)
    else
      return true if ( past_first_rsi_2_period <= 60 &&
        past_second_rsi_2_period <= past_first_rsi_2_period)
    end
    false
  end

  # Chapter 4B
  def b200_r_3?
    today = Date.today

    records_close = EtfPrice.where(name: name).where("date <= '#{today}'").order(date: :desc).limit(5).pluck(:close)

    past_first_rsi_2_period = compute_rsi(records_close[1..3])
    past_second_rsi_2_period = compute_rsi(records_close[0..2])

    if market_opened?
      return true if ( past_first_rsi_2_period >= 40 &&
        past_second_rsi_2_period >= past_first_rsi_2_period &&
        current_rsi(2) > 90)
    else
      return true if ( past_first_rsi_2_period >= 40 &&
        past_second_rsi_2_period >= past_first_rsi_2_period)
    end

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

  def bb(date)
    records_close = EtfPrice.where(name: name).where("date <= '#{date}'").order(date: :desc).limit(20).pluck(:close)
    return nil if records_close.count < 20

    compute_bb(records_close)
  end

  # Last three prices should be above given sma
  def price_above_sma?(period)
    records_close = get_latest_records(:close, 3)
    sma_for_period = current_sma(period)

    return records_close.all? {|close| close > sma_for_period}
  end

  def price_above_sma_200?
    price_above_sma?(200)
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

  def compute_bb(close_prices)
    BollingerBand.new.compute_bollinger(close_prices).first.last.to_f.round(2)
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