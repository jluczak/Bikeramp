require 'rails_helper'

RSpec.describe 'Trip creation', type: :request do
  subject { post '/trips', params: params, headers: headers }

  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let(:params) { {} }

  let(:json_response) { JSON.parse(response.body) }

  it 'has a valid factory' do
    expect(FactoryBot.create(:trip)).to be_valid
  end

  context 'with valid data', vcr: { cassette_name: 'requests/trip_create' } do
    let(:params) { FactoryBot.attributes_for(:trip) }

    it 'returns 201 with json format' do
      subject
      expect(response).to have_http_status(201)
      expect(response.content_type).to eq('application/json')
    end

    it 'creates a trip' do
      expect { subject }.to change { Trip.count }.by(1)
    end

    it 'returns a trip' do
      subject
      expect(json_response['data']['attributes']).to include(
        'start_address' => 'Plac Europejski 2, Warszawa, Polska',
        'destination_address' => 'Leszno 15, Warszawa, Polska',
        'price' => '4.65',
        'distance' => '798.76'
      )
    end
  end

  context 'with invalid data' do
    context 'with both addresses invalid', vcr: { cassette_name: 'requests/trip_create_failure_both_addresses_invalid' } do
      let(:params) do
        {
          start_address: 'fjsjakdk',
          destination_address: 'kadkdfmfd',
          price: 3.54
        }
      end

      it 'returns 422 with json format' do
        subject
        expect(response).to have_http_status(422)
        expect(response.content_type).to eq('application/json')
      end

      it 'does not create a trip' do
        expect { subject }.to_not change { Trip.count }
      end

      it 'returns error' do
        subject
        expect(json_response).to include(
          'destination_address' => ['Could not find address'],
          'start_address' => ['Could not find address']
        )
      end
    end

    context 'with invalid start address', vcr: { cassette_name: 'requests/trip_create_failure_invalid_start_address' } do
      let(:params) do
        {
          start_address: 'fjsjakdk',
          destination_address: 'Leszno 15, Warszawa, Polska',
          price: 3.54
        }
      end

      it 'returns 422 status code' do
        subject
        expect(response).to have_http_status(422)
      end

      it 'does not create a trip' do
        expect { subject }.to_not change { Trip.count }
      end

      it 'returns error' do
        subject
        expect(json_response).to include(
          'start_address' => ['Could not find address']
        )
      end
    end

    context 'with invalid destination address', vcr: { cassette_name: 'requests/trip_create_failure_invalid_destination_address' } do
      let(:params) do
        {
          start_address: 'Leszno 15, Warszawa, Polska',
          destination_address: 'fjsjakdk',
          price: 3.54
        }
      end

      it 'returns 422 status code' do
        subject
        expect(response).to have_http_status(422)
      end

      it 'does not create a trip' do
        expect { subject }.to_not change { Trip.count }
      end

      it 'returns error' do
        subject
        expect(json_response).to include(
          'destination_address' => ['Could not find address']
        )
      end
    end
  end
end
