class AddTransactionTable < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :name, null: false
      t.integer :quantity, null: false
      t.decimal :price, precision: 20, scale: 2, null: false
      t.timestamps
      t.integer :lock_version, null: false
    end
  end
end
