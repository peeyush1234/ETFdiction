class AddColumnStrategyToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :strategy, :string, null: true
  end
end
