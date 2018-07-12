class AddDataLinesTimestampIndex < ActiveRecord::Migration[5.2]
  def change
    remove_index :data_lines, ["timestamp", "device_id"]
    add_index :data_lines, [:device_id, :timestamp, :id], unique: true, order: { device_id: :asc, id: :desc, timestamp: :desc }, name: 'index_device_data_lines_current_sort'
    add_index :data_lines, [:timestamp, :id], order: { id: :desc, timestamp: :desc }, name: 'index_data_lines_current_sort'
  end
end
