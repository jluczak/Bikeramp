require 'rails_helper'

RSpec.describe 'Trip management', type: :request do
  headers = {
    'ACCEPT' => 'application/json'
  }
  it 'has a valid factory' do
    expect(FactoryBot.create(:trip)).to be_valid
  end

  describe 'CREATE trip' do
    it 'creates a trip' do
      VCR.use_cassette('requests/trip_create') do
        expect do
          post '/trips', params: FactoryBot.attributes_for(:trip), headers: headers
        end.to change { Trip.count }.by(1)

        expect(response).to have_http_status(:created)
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

  describe 'UPDATE trip' do
    let(:trip) { FactoryBot.create(:trip, FactoryBot.attributes_for(:trip)) }

    it 'updates a trip' do
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

    describe 'DESTROY trip' do
      trip = FactoryBot.create(:trip, FactoryBot.attributes_for(:trip))

      it 'destroys a trip' do
        expect do
          delete "/trips/#{trip.id}"
        end.to change { Trip.count }.by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end
end
