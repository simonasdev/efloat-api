class AddLengthToTrack < ActiveRecord::Migration[5.2]
  def change
    add_column :tracks, :length, :float
  end
end
