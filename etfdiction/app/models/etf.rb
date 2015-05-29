class Etf < ActiveRecord::Base
  validates :name, presence: true
  validates :date, presence: true
  validates :open, presence: true
  validates :close, presence: true
  validates :high, presence: true
  validates :low, presence: true

  ETF_3X_BULL = {name: "etf_3x_bull", values: ['BAR',	'BRZU',	'BUNT',	'CURE',	'DRN',	'DZK',	'EDC',	'ERX',	'EURL',	'FAS',	'FINU',	'GASL',	'INDL',	'JDST',	'JGBT',	'JNUG',	'JPNL',	'LBJ',	'MATL',	'MIDU',	'NUGT',	'RETL',	'RUSL',	'SOXL',	'SPXL',	'TECL',	'TMF',	'TNA',	'TQQQ',	'TYD',	'UDOW',	'UGAZ',	'UGLD',	'UMDD',	'UPRO',	'URTY',	'USLV',	'UWTI',	'YINN']}.freeze

  ETF_3X_BEAR = {name: "etf_3x_bear", values: ['DGAZ',	'DGLD',	'DPK',	'DRV',	'DSLV',	'DUST',	'DWTI',	'EDZ',	'ERY',	'FAZ',	'FINZ',	'JGBD',	'LBND',	'MIDZ',	'RUSS',	'SBND',	'SDOW',	'SMDD',	'SOXS',	'SPXS',	'SPXU',	'SQQQ',	'SRTY',	'TECS',	'TMV',	'TTT',	'TYO',	'TZA',	'YANG']}.freeze

  ETF_2X_BULL = {name: "etf_2x_bull", values: ['AGQ',	'BDCL',	'BDD',	'BIB',	'BOIL',	'CEFL',	'DAG',	'DDM',	'DGP',	'DIG',	'DVHL',	'DVYL',	'DYY',	'EET',	'EFO',	'EZJ',	'GDAY',	'IGU',	'KRU',	'LMLP',	'LTL',	'MLPL',	'MORL',	'MVV',	'QLD',	'ROM',	'RWXL',	'RXL',	'SAA',	'SDYL',	'SMHD',	'SPLX',	'SSO',	'THHY',	'TVIX',	'UBR',	'UBT',	'UCC',	'UCD',	'UCO',	'UGE',	'UGL',	'UJB',	'ULE',	'UMX',	'UPV',	'UPW',	'URE',	'URR',	'USD',	'UST',	'UVXY',	'UWM',	'UXI',	'UXJ',	'UYG',	'UYM',	'XPP',	'YCL']}.freeze

  ETF_2X_BEAR = {name: "etf_2x_bear", values: ['AGA',	'BIS',	'BOM',	'BZQ',	'CMD',	'CROC',	'DEE',	'DGZ',	'DRR',	'DTO',	'DUG',	'DXD',	'DZZ',	'EEV',	'EFU',	'EPV',	'EUO',	'EWV',	'FXP',	'GLL',	'KOLD',	'MZZ',	'PST',	'QID',	'REW',	'RXD',	'SCC',	'SCIN',	'SCO',	'SDD',	'SDP',	'SDS',	'SIJ',	'SKF',	'SMK',	'SMN',	'SRS',	'SSG',	'SZK',	'TBT',	'TBZ',	'TLL',	'TPS',	'TWM',	'YCS',	'ZSL']}.freeze

  ETF_BULL = {name: "etf_bull", values: ['RSX', 'EWZ', 'INDA', 'EWJ', 'EWY', 'IEV', 'MCHI']}

  def rsi(period)
    records_close = Etf.where(name: name).where("date <= '#{self.date}'").order(date: :desc).limit(period+1).pluck(:close)
    return nil if records_close.count < period + 1
    data_setup = Indicators::Data.new(records_close.reverse)
    data_setup.calc(type: :rsi, params: period).output.last.round(2)
  end

  def sma(period)
    records_close = Etf.where(name: name).where("date <= '#{self.date}'").order(date: :desc).limit(period).pluck(:close)

    return nil if records_close.count < period

    (records_close.sum/period.to_f).to_f.round(2)
  end

  def current_price
    DataFetcher.realtime_price(name)
  end

  # Chapter 3
  def self.rsi_25_etfs
    result = Hash.new{ |h, k| h[k] = [] }
    [ETF_BULL].each do |etfs_hash|
      etfs_hash[:values].each do |etf_name|
        result[etfs_hash[:name]] << etf_name if below_rsi_25?(etf_name)
      end
    end
    result
  end

  # Chapter 2
  def self.day_3_high_low_etfs
    result = Hash.new{ |h, k| h[k] = [] }
    [ETF_BULL].each do |etfs_hash|
      etfs_hash[:values].each do |etf_name|
        result[etfs_hash[:name]] << etf_name if day_3_high_low?(etf_name)
      end
    end
    result
  end

  def self.sma_above_200_etfs
    result = Hash.new{ |h, k| h[k] = [] }

    [ETF_BULL].each do |etfs_hash|
      etfs_hash[:values].each do |etf_name|
        result[etfs_hash[:name]] << etf_name if sma_above_200?(etf_name)
      end
    end

    result
  end

  private

  def self.below_rsi_25?(etf_name)
    etfs = Etf.where(name: etf_name).where("date <= '#{today}'").order(date: :desc).limit(2).reverse
    sma_200 = etfs.last.sma(200)
    return false unless etfs.all? {|etf| etf.close > sma_200}

    puts etfs.last.rsi(4)
    return true if ((etfs.last.rsi(4).round <= 25))
  end

  def self.today
    Date.today.to_s
  end

  def self.sma_above_200?(etf_name)
    etfs = Etf.where(name: etf_name).where("date <= '#{today}'").order(date: :desc).limit(3).reverse
    sma_200 = etfs.last.sma(200)
    return false unless etfs.all? {|etf| etf.close > sma_200}
    true
  end

  def self.day_3_high_low?(etf_name)

    etfs = Etf.where(name: etf_name).where("date <= '#{today}'").order(date: :desc).limit(3).reverse

    sma_200 = etfs.last.sma(200)
    return false unless etfs.all? {|etf| etf.close > sma_200}

    return true if ((etfs[1].high < etfs[0].high) && (etfs[2].high < etfs[1].high)) && ((etfs[1].low < etfs[0].low) && (etfs[2].low < etfs[1].low))

    return false
  end

end