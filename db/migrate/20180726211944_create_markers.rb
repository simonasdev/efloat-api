class CreateMarkers < ActiveRecord::Migration[5.2]
  def change
    create_table :markers do |t|
      t.decimal :latitude, precision: 10, scale: 7
      t.decimal :longitude, precision: 10, scale: 7
      t.integer :kind, default: 0, null: false
      t.text :number
      t.references :race, index: true
      t.references :track, index: true

      t.timestamps
    end
    add_index :markers, :kind
  end
end
