class CreateDrivers < ActiveRecord::Migration[5.2]
  def change
    create_table :drivers do |t|
      t.text :name
      t.integer :kind, default: 0, null: false
      t.jsonb :data, default: {}, null: false

      t.timestamps
    end

    add_index :drivers, :name
    add_index :drivers, :kind
  end
end
