require 'rails_helper'

RSpec.describe 'Trip creation', type: :request do

  let(:headers) { { 'ACCEPT' => 'application/json'} }
  let(:json_response) { JSON.parse(response.body) }

  it 'has a valid factory' do
    expect(FactoryBot.create(:trip)).to be_valid
  end

  context 'valid data' do
    let(:post_action) { post '/trips', params: FactoryBot.attributes_for(:trip), headers: headers }

    it 'returns 201 with json format' do
      VCR.use_cassette('requests/trip_create') do
        post_action
        expect(response).to have_http_status(201)
        expect(response.content_type).to eq('application/json')
      end
    end

    it 'creates a trip' do
      VCR.use_cassette('requests/trip_create') do
        expect{ post_action }.to change { Trip.count }.by(1)
      end
    end

    it 'returns a trip' do
      VCR.use_cassette('requests/trip_create') do
        post_action
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
    let(:post_action) { post '/trips', params: { start_address: 'fjsjakdk',
                             destination_address: 'kadkdfmfd',
                             price: 3.54 }, headers: headers }

    it 'it returns 422 with json format' do
      VCR.use_cassette('requests/trip_create') do
        post_action
        expect(response).to have_http_status(422)
        expect(response.content_type).to eq('application/json')
      end
    end

    it 'it does not create a trip' do
      VCR.use_cassette('requests/trip_create') do
        expect{ post_action }.to_not change { Trip.count }
      end
    end

    it 'it returns error' do
      VCR.use_cassette('requests/trip_create') do
        post_action
        expect(json_response).to include(
          "destination_address" => ["Could not find address"],
          "start_address" => ["Could not find address"]
        )
      end
    end
  end
end
