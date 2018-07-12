class RemoveObsoleteIndicesFromDataLines < ActiveRecord::Migration[5.2]
  def change
    remove_index :data_lines, name: "index_device_data_lines_current_sort"
    remove_index :data_lines, name: "index_data_lines_current_sort"
  end
end
