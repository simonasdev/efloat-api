class AddPublicToRaces < ActiveRecord::Migration[5.2]
  def change
    add_column :races, :public, :boolean, default: false, null: false
  end
end
