class DistanceCalculator
  def initialize(geocoder, start_address, destination_address)
    @geocoder = geocoder
    @start_address = start_address
    @destination_address = destination_address
  end

  def call
    start_point = geocoder.geocode(start_address)
    end_point = geocoder.geocode(destination_address)

    if start_point.success && end_point.success
      start_point.distance_from(end_point, units: :meters)
    else
      messages = [
        start_address: ['Could not find address'],
        destination_address: ['Could not find address']
      ]

      raise AddressNotFound, messages
    end
  end

  private

  attr_reader :geocoder, :start_address, :destination_address
end
