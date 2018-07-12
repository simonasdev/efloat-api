class AddKindAndOnlineToDevices < ActiveRecord::Migration[5.2]
  def change
    add_column :devices, :kind, :integer, default: 0, null: false
    add_index :devices, :kind
    add_column :devices, :online, :boolean, default: false, null: false
  end
end
