class AddAverageSpeedToSpeedExceedEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :speed_exceed_events, :average_speed, :float
  end
end
