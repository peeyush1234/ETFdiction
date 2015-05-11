class RemoveColumnsFromEtfs < ActiveRecord::Migration
  def change
    remove_column :etfs, :avg_gain_14
    remove_column :etfs, :avg_loss_14
  end
end
