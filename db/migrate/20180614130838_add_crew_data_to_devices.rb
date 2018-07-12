class AddCrewDataToDevices < ActiveRecord::Migration[5.2]
  def change
    add_column :devices, :crew_data, :jsonb, default: {}, null: false
  end
end
