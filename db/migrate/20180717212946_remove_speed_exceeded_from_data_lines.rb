class RemoveSpeedExceededFromDataLines < ActiveRecord::Migration[5.2]
  def change
    remove_column :data_lines, :speed_exceeded, :float
  end
end
