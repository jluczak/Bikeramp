require 'rails_helper'

RSpec.describe 'Trip management', type: :request do
  it 'creates a Trip' do
    VCR.use_cassette('requests/trip_management') do
      headers = {
        'ACCEPT' => 'application/json'
      }
      post '/trips', params: { start_address: 'Plac Europejski 2, Warszawa, Polska',
                               destination_address: 'Leszno 15, Warszawa, Polska',
                               price: 4.65 }, headers: headers
      expect(response.content_type).to eq('application/json')
      expect(response).to have_http_status(:created)
      json_response = JSON.parse(response.body)
      expect(json_response['data']['attributes']['distance']).to eq("798.76")
    end
  end
end
