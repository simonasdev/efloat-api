class CreatePoints < ActiveRecord::Migration[5.2]
  def change
    create_table :points do |t|
      t.float :x
      t.float :y
      t.references :track, index: true

      t.timestamps
    end

    add_index :points, [:x, :y], unique: true
  end
end
