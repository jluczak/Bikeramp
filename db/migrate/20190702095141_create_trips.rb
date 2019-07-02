class CreateTrips < ActiveRecord::Migration[5.2]
  def change
    create_table :trips do |t|
      t.string :start_address, null: false
      t.string :destination_address, null: false
      t.decimal :price, precision: 6, scale: 2, null: false

      t.timestamps
    end
  end
end
