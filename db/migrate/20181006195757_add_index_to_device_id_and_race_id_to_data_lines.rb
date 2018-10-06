class AddIndexToDeviceIdAndRaceIdToDataLines < ActiveRecord::Migration[5.2]
  def change
    add_index :data_lines, [:device_id, :race_id]
  end
end
