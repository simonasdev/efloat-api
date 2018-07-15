class FixIndexesForPoints < ActiveRecord::Migration[5.2]
  def change
    remove_index :points, name: 'index_points_on_x_and_y'

    add_index :points, [:x, :y, :track_id], unique: true
    add_index :points, [:x, :y]
  end
end
