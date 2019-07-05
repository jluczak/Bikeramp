require 'rails_helper'

RSpec.describe 'Trip update', type: :request do
  let(:headers) do
    { 'ACCEPT' => 'application/json' }
  end

  let(:json_response) do
    JSON.parse(response.body)
  end

  it 'has a valid factory' do
    expect(FactoryBot.create(:trip)).to be_valid
  end

  let!(:trip) { FactoryBot.create(:trip, FactoryBot.attributes_for(:trip)) }

  context 'valid data' do
    let(:trip_update) do
      patch "/trips/#{trip.id}", params: { start_address: 'Plan Wilsona 2, Warszawa, Polska',
                                           destination_address: 'Żelazna 5, Warszawa, Polska',
                                           price: 2.87 }
    end
    let(:attributes) do
      { 'start_address' => 'Plan Wilsona 2, Warszawa, Polska',
        'destination_address' => 'Żelazna 5, Warszawa, Polska',
        'price' => '2.87',
        'distance' => '4647.54' }
    end

    it 'id returns 200 with json format' do
      VCR.use_cassette('requests/trip_update') do
        trip_update
        expect(response).to have_http_status(200)
        expect(response.content_type).to eq('application/json')
      end
    end

    it 'id updates a trip' do
      VCR.use_cassette('requests/trip_update') do
        trip_update
        get "/trips/#{trip.id}"
        expect(json_response['data']['attributes']).to include(attributes)
      end
    end

    it 'id returns a trip' do
      VCR.use_cassette('requests/trip_update') do
        trip_update
        expect(json_response['data']['attributes']).to include(attributes)
      end
    end
  end

  context 'invalid data' do
    let(:trip_update) do
      patch "/trips/#{trip.id}", params: { start_address: 'fjsjakdk',
                                           destination_address: 'kadkdfmfd',
                                           price: 2.87 }
    end

    let(:attributes) do
      { 'start_address' => 'Plac Europejski 2, Warszawa, Polska',
        'destination_address' => 'Leszno 15, Warszawa, Polska',
        'price' => '4.65',
        'distance' => '798.76' }
    end

    it 'returns 422 in json format' do
      VCR.use_cassette('requests/trip_update') do
        trip_update
        expect(response).to have_http_status(422)
        expect(response.content_type).to eq('application/json')
      end
    end

    it 'does not update the trip' do
      VCR.use_cassette('requests/trip_update') do
        trip_update
        get "/trips/#{trip.id}"
        expect(json_response['data']['attributes']).to include(attributes)
      end
    end

    it 'returns error' do
      VCR.use_cassette('requests/trip_update') do
        trip_update
        expect(json_response).to include(
          'destination_address' => ['Could not find address'],
          'start_address' => ['Could not find address']
        )
      end
    end
  end
end
