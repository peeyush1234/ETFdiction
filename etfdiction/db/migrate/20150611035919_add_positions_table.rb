class AddPositionsTable < ActiveRecord::Migration
  def change
    create_table :positions, id: false do |t|
      t.string :name, null: false
      t.decimal :average_price, precision: 20, scale: 2, null: false
      t.integer :quantity, null: false

      t.timestamps
      t.integer :lock_version, null: false
    end

    add_index :positions, :name, :unique => true
  end
end
