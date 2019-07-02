Geokit.default_units = :kms # others :kms, :nms, :meters
Geokit.default_formula = :sphere
Geokit::Geocoders.request_timeout = 3

Geokit::Geocoders::GoogleGeocoder.api_key = ENV['GOOGLE_API_KEY']
Geokit::Geocoders.provider_order = [:google]
