class DropFloatPoints < ActiveRecord::Migration[5.2]
  def up
    drop_table :float_points
  end
end
