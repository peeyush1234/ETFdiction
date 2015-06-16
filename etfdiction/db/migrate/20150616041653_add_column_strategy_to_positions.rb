class AddColumnStrategyToPositions < ActiveRecord::Migration
  def change
    add_column :positions, :strategy, :string, null: true
  end
end
