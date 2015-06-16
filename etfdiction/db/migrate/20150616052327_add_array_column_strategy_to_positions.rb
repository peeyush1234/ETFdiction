class AddArrayColumnStrategyToPositions < ActiveRecord::Migration
  def change
    add_column :positions, :strategy, :string, array: true, default: []
  end
end
