class AddIndexToDevices < ActiveRecord::Migration[5.2]
  def change
    add_column :devices, :index, :text
  end
end
