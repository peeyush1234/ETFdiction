class FixColumnNameEtf < ActiveRecord::Migration
  def change
    rename_column :etfs, :trading_date, :date
  end
end
