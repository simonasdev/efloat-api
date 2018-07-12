class AddCurrentDataLineIdToDevices < ActiveRecord::Migration[5.2]
  def change
    add_column :devices, :current_data_line_id, :integer
    add_index :devices, :current_data_line_id
  end
end
