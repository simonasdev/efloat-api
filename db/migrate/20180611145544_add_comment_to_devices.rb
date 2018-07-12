class AddCommentToDevices < ActiveRecord::Migration[5.2]
  def change
    add_column :devices, :comment, :text
  end
end
