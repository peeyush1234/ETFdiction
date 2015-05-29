require 'csv'

module DataFetcher

  def self.update_data
    #etf_list = EtfPrice::ETF_2X_BULL[:values] + EtfPrice::ETF_3X_BULL[:values] + EtfPrice::ETF_2X_BEAR[:values] + EtfPrice::ETF_3X_BEAR[:values] + ETF::ETF_BULL[:values]

    etf_list = EtfPrice::ETF_BULL[:values]
    etf_list.each do |etf_name|
      records = csv_data_from_yahoo(etf_name)
      last_trading_date = EtfPrice.where(name: etf_name).order(date: :desc).limit(1).pluck(:date).to_a.first

      if last_trading_date.present?
        records.each do |rec|
          create_record(etf_name, rec, records) if rec[:date] > last_trading_date
        end
      else
        setup_initial_data(etf_name)
      end
    end
  end

  def self.realtime_price(etf)
    # Documentation: http://m.blog.csdn.net/blog/solaris_navi/6730464
    url = "http://finance.google.com/finance/info?client=ig&q=#{etf}"
    data = Manticore.get(url).body
    current_price = JSON.parse(data.split("//").second).first['l'].to_f

    current_price
  end

  private

  def self.create_record(etf_name, rec, records)
    EtfPrice.new(name: etf_name, date: rec[:date], open: rec[:open], close: rec[:close], high: rec[:high], low: rec[:low], volume: rec[:volume]).save!
  end

  def self.csv_data_from_yahoo(sym)
    url = "http://ichart.yahoo.com/table.csv?s=#{sym}"
    data = Manticore.get(url).body
    CSV.new(data, headers: true, header_converters: :symbol).to_a.reverse
  end

  def self.setup_initial_data(etfs_list)
    Array(etfs_list).each do |etf_name|
      records = csv_data_from_yahoo(etf_name)
      records.each do |rec|
        create_record(etf_name, rec, records)
      end
    end
  end
end