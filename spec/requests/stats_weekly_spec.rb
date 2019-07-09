require 'rails_helper'

describe 'Weekly stats', type: :request do
  subject { get '/stats/weekly' }

  let!(:trips) do
    FactoryBot.create_list(:trip, 2)
  end

  let(:json_response) { JSON.parse(response.body) }

  it 'returns 200 status code' do
    subject
    expect(response).to have_http_status(200)
  end

  it 'returns weekly total distance' do
    subject
    expect(json_response).to include("total_distance": "1597,52km")
  end
end