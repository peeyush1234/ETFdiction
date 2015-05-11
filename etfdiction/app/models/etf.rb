class Etf < ActiveRecord::Base
  validates :name, presence: true
  validates :date, presence: true
  validates :open, presence: true
  validates :close, presence: true
  validates :high, presence: true
  validates :low, presence: true

  ETF_3X = ['BAR',	'BRZU',	'BUNT',	'CURE',	'DGAZ',	'DGLD',	'DPK',	'DRN',	'DRV',	'DSLV',	'DUST',	'DWTI',	'DZK',	'EDC',	'EDZ',	'ERX',	'ERY',	'EURL',	'FAS',	'FAZ',	'FINU',	'FINZ',	'GASL',	'INDL',	'JDST',	'JGBD',	'JGBT',	'JNUG',	'JPNL',	'LBJ',	'LBND',	'MATL',	'MIDU',	'MIDZ',	'NUGT',	'RETL',	'RUSL',	'RUSS',	'SBND',	'SDOW',	'SMDD',	'SOXL',	'SOXS',	'SPXL',	'SPXS',	'SPXU',	'SQQQ',	'SRTY',	'TECL',	'TECS',	'TMF',	'TMV',	'TNA',	'TQQQ',	'TTT',	'TYD',	'TYO',	'TZA',	'UDOW',	'UGAZ',	'UGLD',	'UMDD',	'UPRO',	'URTY',	'USLV',	'UWTI',	'YANG',	'YINN'].freeze

  ETF_2X = ['AGA',	'AGQ',	'BDCL',	'BDD',	'BIB',	'BIS',	'BOIL',	'BOM',	'BZQ',	'CEFL',	'CMD',	'CROC',	'DAG',	'DDM',	'DEE',	'DGP',	'DGZ',	'DIG',	'DRR',	'DTO',	'DUG',	'DVHL',	'DVYL',	'DXD',	'DYY',	'DZZ',	'EET',	'EEV',	'EFO',	'EFU',	'EPV',	'EUO',	'EWV',	'EZJ',	'FXP',	'GDAY',	'GLL',	'IGU',	'KOLD',	'KRU',	'LMLP',	'LTL',	'MLPL',	'MORL',	'MVV',	'MZZ',	'PST',	'QID',	'QLD',	'REW',	'ROM',	'RWXL',	'RXD',	'RXL',	'SAA',	'SCC',	'SCIN',	'SCO',	'SDD',	'SDP',	'SDS',	'SDYL',	'SIJ',	'SKF',	'SMHD',	'SMK',	'SMN',	'SPLX',	'SRS',	'SSG',	'SSO',	'SZK',	'TBT',	'TBZ',	'THHY',	'TLL',	'TPS',	'TVIX',	'TWM',	'UBR',	'UBT',	'UCC',	'UCD',	'UCO',	'UGE',	'UGL',	'UJB',	'ULE',	'UMX',	'UPV',	'UPW',	'URE',	'URR',	'USD',	'UST',	'UVXY',	'UWM',	'UXI',	'UXJ',	'UYG',	'UYM',	'XPP',	'YCL',	'YCS',	'ZSL'].freeze

  ETF_1X =

  def rsi(period)
    records_close = Etf.where(name: name).where("date <= '#{date}'").order(date: :desc).limit(period+1).pluck(:close)
    return nil if records_close.count < period + 1
    data_setup = Indicators::Data.new(records_close.reverse)
    data_setup.calc(type: :rsi, params: period).output.last.round(2)
  end

  def sma(period)
    records_close = Etf.where(name: name).where("date <= '#{date}'").order(date: :desc).limit(period).pluck(:close)

    return nil if records_close.count < period

    (records_close.sum/period.to_f).to_f.round(2)
  end

  def self.day_3_high_low_etfs
    today = Date.today.to_s

    result_3x = []
    ETF_3X.each do |etf_name|
      result_3x << etf_name if day_3_high_low?(etf_name)
    end

    result_2x = []
    ETF_2X.each do |etf_name|
      result_2x << etf_name if day_3_high_low?(etf_name)
    end

    {etf_3x: result_3x, etf_2x: result_2x}
  end

  private

  def self.day_3_high_low?(etf_name)
    today = Date.today.to_s
    etfs = Etf.where(name: etf_name).where("date <= '#{today}'").order(date: :desc).limit(3).reverse
    sma_200 = etfs.last.sma(200)

    return true if etfs.all? {|etf| etf.close > sma_200} && ((etfs[1].high < etfs[0].high) && (etfs[2].high < etfs[1].high)) && ((etfs[1].low < etfs[0].low) && (etfs[2].low < etfs[1].low))

    return false
  end

end