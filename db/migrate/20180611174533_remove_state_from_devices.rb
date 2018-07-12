class RemoveStateFromDevices < ActiveRecord::Migration[5.2]
  def change
    remove_column :devices, :state, :text
  end
end
