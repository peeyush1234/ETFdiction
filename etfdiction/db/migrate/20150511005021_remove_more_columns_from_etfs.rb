class RemoveMoreColumnsFromEtfs < ActiveRecord::Migration
  def change
    remove_column :etfs, :rsi_14
    remove_column :etfs, :ma_200
  end
end
