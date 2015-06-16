class ChangeArrayColumnStrategyPositions < ActiveRecord::Migration
  def change
    remove_column :positions, :strategy
    add_column :positions, :strategy, :text, array: true, default: []
  end
end
