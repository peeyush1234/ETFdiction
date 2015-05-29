class ChangeEtfTableName < ActiveRecord::Migration
  def change
    rename_table :etfs, :etf_prices
  end
end
