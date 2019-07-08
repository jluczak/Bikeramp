require 'rails_helper'

describe DistanceCalculator do
  subject do
    described_class.new(
        Geokit::Geocoders::GoogleGeocoder,
        start_address,
        destination_address
    )
  end

  context 'with valid params', vcr: { cassette_name: 'requests/trip_create' } do
    let(:start_address) { 'Plac Europejski 2, Warszawa, Polska' }
    let(:destination_address) { 'Leszno 15, Warszawa, Polska' }
    let(:returned_distance) { subject.call[:distance] }

    it 'returns distance from geocoder' do
      expect(returned_distance.round(2)).to eq(798.76)
    end
  end
end

