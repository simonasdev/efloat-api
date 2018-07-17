class CreateSpeedExceedEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :speed_exceed_events do |t|
      t.references :race, null: false, index: true
      t.references :track, null: false, index: true
      t.references :device, null: false, index: true

      t.integer :data_line_ids, array: true, null: false

      t.integer :seconds, null: false, index: true
    end
  end
end
