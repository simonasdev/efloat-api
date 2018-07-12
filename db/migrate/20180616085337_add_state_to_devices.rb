class AddStateToDevices < ActiveRecord::Migration[5.2]
  def change
    add_column :devices, :state, :text
    add_index :devices, :state
  end
end
