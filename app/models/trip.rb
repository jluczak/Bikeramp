class Trip < ApplicationRecord
  before_save :calculate_distance
  validates_presence_of :start_address, :destination_address
  validates :price, numericality: { greater_than: 0 }

  private

  def calculate_distance
    start_point = get_coordinates(start_address)
    end_point = get_coordinates(destination_address)
    distance = start_point.distance_from(end_point, units: :kms)
    self.distance = distance.round(2)
  end

  def get_coordinates(location)
    Geokit::Geocoders::GoogleGeocoder.geocode(location)
  end
end
