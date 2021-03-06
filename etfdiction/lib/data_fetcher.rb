require 'csv'

module DataFetcher

  def self.update_data
    etf_list = Etf::ETF_BULL[:values]
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
    # http://www.google.com/finance/getprices?q=BRZU&f=o,h,c,l&p=1D&i=80000
    # Documentation: http://m.blog.csdn.net/blog/solaris_navi/6730464
    url = "http://finance.google.com/finance/info?client=ig&q=#{etf}"
    data = Manticore.get(url).body
    parsed_data = JSON.parse(data.split("//").second).first
    current_price = parsed_data['l'].to_f
    current_date = Date.parse(parsed_data['lt_dts'])

    {price: current_price, date: current_date}
  end

  def self.realtime_from_google(etf)
    url = "http://www.google.com/finance/getprices?q=#{etf}&f=o,h,c,l&p=1D"
    data = Manticore.get(url).body.split("\n").last.split(',').map(&:to_f)
    {close: data[0], high: data[1], low: data[2], open: data[3]}
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