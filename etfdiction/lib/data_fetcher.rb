require 'csv'

module DataFetcher

  def self.update_data(etf_list)
    etf_list.each do |etf|
      csv = csv_data_from_yahoo(etf)
      last_trading_date = Etf.where(name: etf).order(date: :desc).limit(1).pluck(:date).to_a.first
      if last_trading_date.present?
        csv.to_a.each do |rec|
          puts "rec date: #{rec[:date]} and last trading date #{last_trading_date}"
          if rec[:date] > last_trading_date
            Etf.new(name: etf, date: rec[:date], open: rec[:open], close: rec[:close], high: rec[:high], low: rec[:low], volume: rec[:volume]).save!
          else
            break
          end
        end
      else
        setup_initial_data(etf)
      end
    end
  end

  private

  def self.csv_data_from_yahoo(sym)
    url = "http://ichart.yahoo.com/table.csv?s=#{sym}"
    data = Manticore.get(url).body
    CSV.new(data, headers: true, header_converters: :symbol)
  end

  def self.setup_initial_data(etfs_list)
    Array(etfs_list).each do |etf|
      csv = csv_data_from_yahoo(etf)
      csv.to_a.each do |rec|
        Etf.new(name: etf, date: rec[:date], open: rec[:open], close: rec[:close], high: rec[:high], low: rec[:low], volume: rec[:volume]).save!
      end
    end
  end

end