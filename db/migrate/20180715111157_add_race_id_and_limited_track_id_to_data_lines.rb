class AddRaceIdAndLimitedTrackIdToDataLines < ActiveRecord::Migration[5.2]
  def change
    add_reference :data_lines, :race, index: true
    add_reference :data_lines, :limited_track, index: true
  end
end
