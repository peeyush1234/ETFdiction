require 'csv'

module DataFetcher

  def self.update_data(etf_list)
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
    ma_200 = compute_ma(etf_name, rec, 200)
    avg_gain_14 = compute_avg_gain(etf_name, rec, 14)
    avg_loss_14 = compute_avg_loss(etf_name, rec, 14)
    rsi_14 = compute_rsi(avg_gain_14, avg_loss_14)
    Etf.new(name: etf_name, date: rec[:date], open: rec[:open], close: rec[:close], high: rec[:high], low: rec[:low], volume: rec[:volume], ma_200: ma_200, avg_gain_14: avg_gain_14, avg_loss_14: avg_loss_14, rsi_14: rsi_14).save!
  end

  def self.compute_rsi(avg_gain, avg_loss)
    return nil if avg_gain.blank? || avg_loss.blank?
    rs = avg_gain/avg_loss
    return (100.to_f - (100.to_f/(1 + rs))).round(2)
  end

  def self.compute_avg_loss(etf_name, rec, period)
    old_records = Etf.where(name: etf_name).where("date < '#{rec[:date]}'").order(date: :desc).limit(period - 1).to_a
    return nil if old_records.size < period - 1

    #sum of loss
    today_change = rec[:close].to_f - rec[:open].to_f
    total_loss = today_change < 0 ? today_change.abs : 0
    old_records.each do |old_record|
      negative_change = old_record[:open] - old_record[:close]
      total_loss += negative_change if negative_change > 0
    end

    return (total_loss.to_f/period.to_f).round(2)
  end

  def self.compute_avg_gain(etf_name, rec, period)
    old_records = Etf.where(name: etf_name).where("date < '#{rec[:date]}'").order(date: :desc).limit(period - 1).to_a
    return nil if old_records.size < period - 1

    #sum of gains
    today_change = rec[:close].to_f - rec[:open].to_f
    total_gain = today_change > 0 ? today_change : 0
    old_records.each do |old_record|
      change = old_record[:close] - old_record[:open]
      total_gain += change if change > 0
    end

    return (total_gain.to_f/period.to_f).round(2)
  end

  def self.xcompute_avg_loss(etf_name, rec, period)
    previous_day_record = Etf.where(name: etf_name).where("date < '#{rec[:date]}'").order(date: :desc).limit(1).first

    if previous_day_record.present? && previous_day_record.send("avg_loss_#{period}").present?
      today_change = rec[:close].to_f - rec[:open].to_f
      today_loss = today_change < 0 ? today_change.abs : 0
      today_avg_loss = ((previous_day_record.send("avg_loss_#{period}") * (period-1)) + today_loss)/period.to_f
      return today_avg_loss.round(2)
    end

    old_records = Etf.where(name: etf_name).where("date < '#{rec[:date]}'").order(date: :desc).limit(period - 1).to_a
    return nil if old_records.size < period - 1

    #sum of loss
    today_change = rec[:close].to_f - rec[:open].to_f
    total_loss = today_change < 0 ? today_change.abs : 0
    old_records.each do |old_record|
      negative_change = old_record[:open] - old_record[:close]
      total_loss += negative_change if negative_change > 0
    end

    return (total_loss.to_f/period.to_f).round(2)
  end

  def self.xcompute_avg_gain(etf_name, rec, period)
    previous_day_record = Etf.where(name: etf_name).where("date < '#{rec[:date]}'").order(date: :desc).limit(1).first

    if previous_day_record.present? && previous_day_record.send("avg_gain_#{period}").present?
      today_change = rec[:close].to_f - rec[:open].to_f
      today_gain = today_change > 0 ? today_change : 0
      today_avg_gain = ((previous_day_record.send("avg_gain_#{period}") * (period-1)) + today_gain)/period.to_f
      return today_avg_gain.round(2)
    end

    old_records = Etf.where(name: etf_name).where("date < '#{rec[:date]}'").order(date: :desc).limit(period - 1).to_a
    return nil if old_records.size < period - 1

    #sum of gains
    today_change = rec[:close].to_f - rec[:open].to_f
    total_gain = today_change > 0 ? today_change : 0
    old_records.each do |old_record|
      change = old_record[:close] - old_record[:open]
      total_gain += change if change > 0
    end

    return (total_gain.to_f/period.to_f).round(2)
  end

  # Doesn't require to store in database
  def self.compute_ma(etf_name, rec, period)
    old_records = Etf.where(name: etf_name).where("date < '#{rec[:date]}'").order(date: :desc).limit(period-1).to_a

    return nil if old_records.count < period-1

    sum_close = rec[:close].to_f + old_records.map(&:close).sum
    (sum_close/period.to_f).round(2)
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

#DataFetcher.update_data(Etf::ETF_3X)