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
      raise AddressNotFound, generate_error_messages(start_point, end_point)
    end
  end

  private

  def generate_error_messages(start_point, end_point)
    messages = {}
    messages.merge!(start_address: ['Could not find address']) unless start_point.success
    messages.merge!(destination_address: ['Could not find address']) unless end_point.success

    [messages]
  end

  attr_reader :geocoder, :start_address, :destination_address
end
