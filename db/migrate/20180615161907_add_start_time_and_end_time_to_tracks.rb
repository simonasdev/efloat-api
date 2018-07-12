class AddStartTimeAndEndTimeToTracks < ActiveRecord::Migration[5.2]
  def change
    add_column :tracks, :start_time, :datetime
    add_column :tracks, :end_time, :datetime
  end
end
