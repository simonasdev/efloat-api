class AddSpeedExceedProcessedToRaces < ActiveRecord::Migration[5.2]
  def change
    add_column :races, :speed_exceed_processed, :boolean, default: false
  end
end
