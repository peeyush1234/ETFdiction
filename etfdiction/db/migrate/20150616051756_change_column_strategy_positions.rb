class ChangeColumnStrategyPositions < ActiveRecord::Migration
  def change
    remove_column :positions, :strategy
  end
end
