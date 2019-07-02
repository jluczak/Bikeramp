class CreateTrips < ActiveRecord::Migration[5.2]
  def change
    create_table :trips do |t|
      t.string :start_address
      t.string :destination_address
      t.decimal :price, precision: 6, scale: 2

      t.timestamps
    end
  end
end
