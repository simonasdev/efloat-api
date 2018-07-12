class AddKindToTracks < ActiveRecord::Migration[5.2]
  def change
    add_column :tracks, :kind, :integer, default: 0, null: false
    add_column :tracks, :name, :text
    add_index :tracks, :kind
  end
end
