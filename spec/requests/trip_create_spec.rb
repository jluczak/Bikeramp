require 'rails_helper'

RSpec.describe 'Trip creation', type: :request do
  headers = {
    'ACCEPT' => 'application/json'
  }
  
  let(:action) do
      post '/trips', params: FactoryBot.attributes_for(:trip), headers: headers
  end

  it 'creates a trip' do
    VCR.use_cassette('requests/trip_create') do
      expect { action }.to change { Trip.count }.by(1)
      expect(response).to have_http_status(:created)
    end
  end

  it 'returns a trip' do
    VCR.use_cassette('requests/trip_create') do
      action
      json_response = JSON.parse(response.body)
      expect(response.content_type).to eq('application/json')
      expect(json_response['data']['attributes']).to include(
        "start_address" =>  'Plac Europejski 2, Warszawa, Polska',
        "destination_address" => 'Leszno 15, Warszawa, Polska',
        "price" => "4.65",
        "distance" => '798.76'
      )
    end
  end
end
