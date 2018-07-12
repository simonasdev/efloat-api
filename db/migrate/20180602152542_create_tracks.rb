class CreateTracks < ActiveRecord::Migration[5.2]
  def change
    create_table :tracks do |t|
      t.references :race, index: true
      t.float :speed_limit
      t.jsonb :route

      t.timestamps
    end
  end
end
