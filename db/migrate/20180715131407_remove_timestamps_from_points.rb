class RemoveTimestampsFromPoints < ActiveRecord::Migration[5.2]
  def change
    remove_column :points, :created_at
    remove_column :points, :updated_at
  end
end
