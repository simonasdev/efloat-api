class AddPositionToDevices < ActiveRecord::Migration[5.2]
  def change
    add_column :devices, :position, :text
    add_index :devices, :position
  end
end
