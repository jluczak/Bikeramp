class Trip < ApplicationRecord
  before_save :calculate_distance
  validates_presence_of :start_address, :destination_address
  validates :price, numericality: { greater_than: 0 }

  private

  def calculate_distance
    start_coordinates = get_coordinates(start_address)
    destination_coordinates = get_coordinates(destination_address)
    distance = start_coordinates.distance_from(destination_coordinates, :units=>:kms)
    self.distance = distance.round(2)
  end

  def get_coordinates(location)
    Geokit::Geocoders::GoogleGeocoder.geocode(location)
  end
end
