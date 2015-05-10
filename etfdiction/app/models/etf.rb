class Etf < ActiveRecord::Base
  validates :name, presence: true
  validates :date, presence: true
  validates :open, presence: true
  validates :close, presence: true
  validates :high, presence: true
  validates :low, presence: true

  ETF_3X = ['BRZU'].freeze
  #ETF_3X = ['BAR',	'BRZU',	'BUNT',	'CURE',	'DGAZ',	'DGLD',	'DPK',	'DRN',	'DRV',	'DSLV',	'DUST',	'DWTI',	'DZK',	'EDC',	'EDZ',	'ERX',	'ERY',	'EURL',	'FAS',	'FAZ',	'FINU',	'FINZ',	'GASL',	'INDL',	'JDST',	'JGBD',	'JGBT',	'JNUG',	'JPNL',	'LBJ',	'LBND',	'MATL',	'MIDU',	'MIDZ',	'NUGT',	'RETL',	'RUSL',	'RUSS',	'SBND',	'SDOW',	'SMDD',	'SOXL',	'SOXS',	'SPXL',	'SPXS',	'SPXU',	'SQQQ',	'SRTY',	'TECL',	'TECS',	'TMF',	'TMV',	'TNA',	'TQQQ',	'TTT',	'TYD',	'TYO',	'TZA',	'UDOW',	'UGAZ',	'UGLD',	'UMDD',	'UPRO',	'URTY',	'USLV',	'UWTI',	'YANG',	'YINN'].freeze
end