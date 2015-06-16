class ChangeColumnStrategyTransactions < ActiveRecord::Migration
  def change
    remove_column :transactions, :strategy
  end
end
