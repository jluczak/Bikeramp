class TripSerializer
  include FastJsonapi::ObjectSerializer
  attributes :start_address, :destination_address, :price, :distance
end
