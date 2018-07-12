class RemovePhoneNumbersAndDeviceHandlers < ActiveRecord::Migration[5.2]
  def change
    drop_table :phone_numbers
    drop_table :device_handlers
  end
end
