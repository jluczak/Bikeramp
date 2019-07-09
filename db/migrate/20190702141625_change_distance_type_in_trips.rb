class ChangeDistanceTypeInTrips < ActiveRecord::Migration[5.2]
  def self.up
    change_column :trips, :distance, :decimal, precision: 10, scale: 2, null: false
  end

  def self.down
    change_column :trips, :distance, :float
  end
end
