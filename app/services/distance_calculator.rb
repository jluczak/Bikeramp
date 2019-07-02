class DistanceCalculator
  def initialize(start_address, destination_address)
    @start_address = start_address
    @destination_address = destination_address
  end

  def call
    start_point = get_coordinates(@start_address)
    end_point = get_coordinates(@destination_address)
    start_point.distance_from(end_point, units: :meters)
  end

  def get_coordinates(location)
    Geokit::Geocoders::GoogleGeocoder.geocode(location)
  end
end
