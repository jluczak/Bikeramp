require 'rails_helper'

RSpec.describe 'Trip update', type: :request do
  headers = {
    'ACCEPT' => 'application/json'
  }
  it 'has a valid factory' do
    expect(FactoryBot.create(:trip)).to be_valid
  end

  let(:trip) { FactoryBot.create(:trip, FactoryBot.attributes_for(:trip)) }

  it 'updates and returns a trip' do
    VCR.use_cassette('requests/trip_update') do
      patch "/trips/#{trip.id}", params: { start_address: 'Plan Wilsona 2, Warszawa, Polska',
                                           destination_address: 'Żelazna 5, Warszawa, Polska',
                                           price: 2.87 }
      get "/trips/#{trip.id}"
      json_response = JSON.parse(response.body)
      expect(response.content_type).to eq('application/json')
      expect(json_response['data']['attributes']).to include(
        "start_address" =>  'Plan Wilsona 2, Warszawa, Polska',
        "destination_address" => 'Żelazna 5, Warszawa, Polska',
        "price" => "2.87",
        "distance" => '4647.54'
      )
    end
  end
end
