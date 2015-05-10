class AddColumnMa200 < ActiveRecord::Migration
  def change
    add_column :etfs, :ma_200, :decimal
  end
end
