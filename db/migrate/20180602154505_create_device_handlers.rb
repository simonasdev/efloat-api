class CreateDeviceHandlers < ActiveRecord::Migration[5.2]
  def change
    create_table :device_handlers do |t|
      t.references :device, index: true
      t.references :phone_number, index: true

      t.timestamps
    end
  end
end
