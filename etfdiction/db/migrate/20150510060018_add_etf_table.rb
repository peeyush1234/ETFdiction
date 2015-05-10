class AddEtfTable < ActiveRecord::Migration
  def change
    create_table :etfs, id: false do |t|
      t.string :name, null: false
      t.datetime :trading_date, null: false
      t.decimal :open, precision: 20, scale: 2, null: false
      t.decimal :close, precision: 20, scale: 2, null: false
      t.decimal :high, precision: 20, scale: 2, null: false
      t.decimal :low, precision: 20, scale: 2, null: false
      t.integer :volume, null: false

      t.timestamps
      t.integer :lock_version, null: false
    end

    add_index :etfs, [:name, :trading_date], :unique => true, :name => 'primary_key_idx'
  end
end
