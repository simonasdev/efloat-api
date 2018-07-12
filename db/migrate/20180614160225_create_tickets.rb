class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
      t.text :identifier
      t.text :barcode
      t.boolean :passed
      t.boolean :can_enter

      t.timestamps
    end
    add_index :tickets, :barcode
  end
end
