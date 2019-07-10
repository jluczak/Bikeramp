require 'rails_helper'

RSpec.describe 'Trip index', type: :request do
  let(:json_response) { JSON.parse(response.body) }

  it 'has a valid factory' do
    expect(FactoryBot.create(:trip)).to be_valid
  end

  let(:get_trips) { get '/trips' }

  let!(:trip) { FactoryBot.create(:trip) }

  it 'returns 200 with json format' do
    get_trips
    expect(response).to have_http_status(200)
    expect(response.content_type).to eq('application/json')
  end

  it 'returns expected attributes' do
    get_trips
    json_response = JSON.parse(response.body)
    expect(json_response['data']
             .first['attributes'].keys)
      .to eq(["start_address", "destination_address", "price", "distance"])
  end
end
