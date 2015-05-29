class EtfPrice < ActiveRecord::Base
  validates :name, presence: true
  validates :date, presence: true
  validates :open, presence: true
  validates :close, presence: true
  validates :high, presence: true
  validates :low, presence: true

  def rsi(period)
    records_close = EtfPrice.where(name: name).where("date <= '#{self.date}'").order(date: :desc).limit(period+1).pluck(:close)
    return nil if records_close.count < period + 1
    data_setup = Indicators::Data.new(records_close.reverse)
    data_setup.calc(type: :rsi, params: period).output.last.round(2)
  end

  def sma(period)
    records_close = EtfPrice.where(name: name).where("date <= '#{self.date}'").order(date: :desc).limit(period).pluck(:close)

    return nil if records_close.count < period

    (records_close.sum/period.to_f).to_f.round(2)
  end

  # Chapter 4
  def self.r_3_etfs
    result = Hash.new{ |h, k| h[k] = [] }
    [ETF_BULL].each do |etfs_hash|
      etfs_hash[:values].each do |etf_name|
        result[etfs_hash[:name]] << etf_name if r_3?(etf_name)
      end
    end
    result
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

  def self.r_3(etf)
    current_
  end

  def self.below_rsi_25?(etf_name)
    etfs = EtfPrice.where(name: etf_name).where("date <= '#{today}'").order(date: :desc).limit(2).reverse
    sma_200 = etfs.last.sma(200)
    return false unless etfs.all? {|etf| etf.close > sma_200}

    puts etfs.last.rsi(4)
    return true if ((etfs.last.rsi(4).round <= 25))
  end

  def self.today
    Date.today.to_s
  end

  def self.sma_above_200?(etf_name)
    etfs = EtfPrice.where(name: etf_name).where("date <= '#{today}'").order(date: :desc).limit(3).reverse
    sma_200 = etfs.last.sma(200)
    return false unless etfs.all? {|etf| etf.close > sma_200}
    true
  end

  def self.day_3_high_low?(etf_name)

    etfs = EtfPrice.where(name: etf_name).where("date <= '#{today}'").order(date: :desc).limit(3).reverse

    sma_200 = etfs.last.sma(200)
    return false unless etfs.all? {|etf| etf.close > sma_200}

    return true if ((etfs[1].high < etfs[0].high) && (etfs[2].high < etfs[1].high)) && ((etfs[1].low < etfs[0].low) && (etfs[2].low < etfs[1].low))

    return false
  end

end