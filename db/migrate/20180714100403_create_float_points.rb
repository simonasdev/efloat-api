class CreateFloatPoints < ActiveRecord::Migration[5.2]
  def change
    create_table :float_points do |t|
      t.float :x
      t.float :y
      t.references :track, index: true

      t.timestamps
    end

    add_index :float_points, [:x, :y], unique: true
  end
end
