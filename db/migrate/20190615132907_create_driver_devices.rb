class CreateDriverDevices < ActiveRecord::Migration[5.2]
  def change
    create_table :driver_devices do |t|
      t.references :driver, index: true
      t.references :device, index: true
      t.references :race, index: true
      t.text :position
      t.text :state
      t.text :comment

      t.timestamps
    end

    add_index :driver_devices, :position
    add_index :driver_devices, :state
  end
end
