class CreateDataLines < ActiveRecord::Migration[5.2]
  def change
    create_table :data_lines do |t|
      t.references :device, index: true
      t.text :data
      t.datetime :timestamp
      t.float :battery_voltage
      t.decimal :latitude, precision: 10, scale: 7
      t.decimal :longitude, precision: 10, scale: 7
      t.text :cardinal_direction
      t.float :altitude
      t.integer :orientation, default: 0
      t.integer :sos_count
      t.integer :ok_count
      t.boolean :check, default: false, null: false

      t.timestamps
    end
  end
end
