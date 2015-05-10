class AddColumnRsi14 < ActiveRecord::Migration
  def change
    add_column :etfs, :rsi_14, :decimal
  end
end
