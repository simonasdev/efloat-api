class AddSpeedToDataLines < ActiveRecord::Migration[5.2]
  def change
    add_column :data_lines, :speed, :float
  end
end
