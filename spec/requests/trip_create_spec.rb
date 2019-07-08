require 'rails_helper'

RSpec.describe 'Trip creation', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let(:json_response) { JSON.parse(response.body) }

  it 'has a valid factory' do
    expect(FactoryBot.create(:trip)).to be_valid
  end

  context 'with valid data', vcr: { cassette_name: 'requests/trip_create' } do
    let(:trip_creation) { post '/trips', params: FactoryBot.attributes_for(:trip), headers: headers }

    it 'returns 201 with json format' do
      trip_creation
      expect(response).to have_http_status(201)
      expect(response.content_type).to eq('application/json')
    end

    it 'creates a trip' do
      expect { trip_creation }.to change { Trip.count }.by(1)
    end

    it 'returns a trip' do
      trip_creation
      expect(json_response['data']['attributes']).to include(
        'start_address' => 'Plac Europejski 2, Warszawa, Polska',
        'destination_address' => 'Leszno 15, Warszawa, Polska',
        'price' => '4.65',
        'distance' => '798.76'
      )
    end
  end

  context 'with invalid data', vcr: { cassette_name: 'requests/trip_create' } do
    let(:trip_creation) do
      post '/trips', params: { start_address: 'fjsjakdk',
        destination_address: 'kadkdfmfd',
        price: 3.54 }, headers: headers
    end

    it 'returns 422 with json format' do
      trip_creation
      expect(response).to have_http_status(422)
      expect(response.content_type).to eq('application/json')
    end

    it 'does not create a trip' do
      expect { trip_creation }.to_not change { Trip.count }
    end

    it 'returns error' do
      trip_creation
      expect(json_response).to include(
        'destination_address' => ['Could not find address'],
        'start_address' => ['Could not find address']
      )
    end
  end
end
