class DistanceCalculator
  def initialize(geocoder, start_address, destination_address)
    @geocoder = geocoder
    @start_address = start_address
    @destination_address = destination_address
    @errors = ActiveModel::Errors.new(self)
  end

  def call
    @distance = start_point.distance_from(end_point, units: :meters)
    returned_object
  end

  private

  attr_accessor :errors, :distance

  def start_point
    @start_point ||= get_coordinates(@start_address, "start_address")
  end

  def end_point
    @end_point ||= get_coordinates(@destination_address, "destination_address")
  end

  def get_coordinates(location, key)
    @geocoder.geocode(location).tap do |geo|
      errors.add(key, "Could not find address") unless geo.success
    end
  end

  def returned_object
    {
      distance: distance,
      errors: errors
    }
  end
end
