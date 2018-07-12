class AddIndexToTimestampToDataLines < ActiveRecord::Migration[5.2]
  def change
    add_index :data_lines, [:timestamp, :device_id]
  end
end
