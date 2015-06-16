class RemoveColumnStrategyPositions < ActiveRecord::Migration
  def change
    remove_column :transactions, :strategy
    remove_column :positions, :strategy
  end
end
