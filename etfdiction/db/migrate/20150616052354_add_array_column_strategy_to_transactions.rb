class AddArrayColumnStrategyToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :strategy, :string, array: true, default: []
  end
end
