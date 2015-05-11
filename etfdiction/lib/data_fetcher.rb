require 'csv'

module DataFetcher

  def self.update_data
    etf_list = Etf::ETF_2X + Etf::ETF_3X
    etf_list.each do |etf_name|
      records = csv_data_from_yahoo(etf_name)
      last_trading_date = Etf.where(name: etf_name).order(date: :desc).limit(1).pluck(:date).to_a.first

      if last_trading_date.present?
        records.each do |rec|
          create_record(etf_name, rec, records) if rec[:date] > last_trading_date
        end
      else
        setup_initial_data(etf_name)
      end
    end
  end

  private

  def self.create_record(etf_name, rec, records)
    Etf.new(name: etf_name, date: rec[:date], open: rec[:open], close: rec[:close], high: rec[:high], low: rec[:low], volume: rec[:volume]).save!
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

#DataFetcher.update_data