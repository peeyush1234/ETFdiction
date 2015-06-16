class AddColumnStrategyPositions < ActiveRecord::Migration
  def change
    add_column :transactions, :strategy, :string, null: true
    add_column :positions, :strategy, :string, null: true
  end
end
