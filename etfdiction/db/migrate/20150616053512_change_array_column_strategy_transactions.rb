class ChangeArrayColumnStrategyTransactions < ActiveRecord::Migration
  def change
    remove_column :transactions, :strategy
    add_column :transactions, :strategy, :text, array: true, default: []
  end
end
