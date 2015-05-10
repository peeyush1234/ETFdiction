class AddColumnAvgGainLoss14 < ActiveRecord::Migration
  def change
    add_column :etfs, :avg_gain_14, :decimal
    add_column :etfs, :avg_loss_14, :decimal
  end
end
