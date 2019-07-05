require 'rails_helper'

RSpec.describe 'Trip management', type: :request do
  headers = {
    'ACCEPT' => 'application/json'
  }
  it 'has a valid factory' do
    expect(FactoryBot.create(:trip)).to be_valid
  end

  describe 'CREATE trip' do
    context 'valid data' do
      it 'creates a trip' do
        VCR.use_cassette('requests/trip_create') do
          expect do
            post '/trips', params: FactoryBot.attributes_for(:trip), headers: headers
          end.to change { Trip.count }.by(1)

          expect(response).to have_http_status(201)
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

    context 'invalid data' do
      it 'it does not create a trip' do
        VCR.use_cassette('requests/trip_create') do
          expect do
            post '/trips', params: { start_address: 'fjsjakdk',
                                     destination_address: 'kadkdfmfd',
                                     price: 3.54 }, headers: headers
          end.to_not change { Trip.count }

          expect(response).to have_http_status(422)
          json_response = JSON.parse(response.body)
          expect(response.content_type).to eq('application/json')
          expect(json_response).to include(
            "destination_address" => ["Could not find address"],
            "start_address" => ["Could not find address"]
          )
        end
      end
    end
  end

  describe 'UPDATE trip' do
    let(:trip) { FactoryBot.create(:trip, FactoryBot.attributes_for(:trip)) }

    context 'valid data' do
      it 'id does not update a trip' do
        VCR.use_cassette('requests/trip_update') do
          patch "/trips/#{trip.id}", params: { start_address: 'Plan Wilsona 2, Warszawa, Polska',
                                               destination_address: 'Żelazna 5, Warszawa, Polska',
                                               price: 2.87 }
          expect(response).to have_http_status(422)
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
    context 'invalid data' do
      it 'updates a trip' do
        VCR.use_cassette('requests/trip_update') do
          patch "/trips/#{trip.id}", params: { start_address: 'fjsjakdk',
                                               destination_address: 'kadkdfmfd',
                                               price: 2.87 }
          get "/trips/#{trip.id}"
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
  end

    describe 'DESTROY trip' do
      trip = FactoryBot.create(:trip, FactoryBot.attributes_for(:trip))

      it 'destroys a trip' do
        expect do
          delete "/trips/#{trip.id}"
        end.to change { Trip.count }.by(-1)
        expect(response).to have_http_status(204)
      end
    end
end
