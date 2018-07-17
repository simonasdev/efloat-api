class CreateSpeedExceedDataLine < ActiveRecord::Migration[5.2]
  def change
    create_table :speed_exceed_data_lines do |t|
      t.bigint    :race_id
      t.bigint    :limited_track_id
      t.bigint    :device_id
      t.text      :data
      t.datetime  :timestamp
      t.float     :battery_voltage
      t.decimal   :latitude, precision: 10, scale: 7
      t.decimal   :longitude, precision: 10, scale: 7
      t.text      :cardinal_direction
      t.float     :altitude
      t.integer   :orientation, default: 0
      t.integer   :sos_count
      t.integer   :ok_count
      t.boolean   :check, default: false, null: false
      t.float     :speed
      t.float     :speed_exceeded

      t.timestamps
    end

    add_index :speed_exceed_data_lines, :race_id
    add_index :speed_exceed_data_lines, :device_id
    add_index :speed_exceed_data_lines, :limited_track_id
  end
end
