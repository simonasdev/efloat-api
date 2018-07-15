class AddSpeedExceededToDataLines < ActiveRecord::Migration[5.2]
  def change
    add_column :data_lines, :speed_exceeded, :float
  end
end
