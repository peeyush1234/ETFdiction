class ChangeDateColumnToString < ActiveRecord::Migration
  def change
    change_column :etfs, :date, :string
  end
end
