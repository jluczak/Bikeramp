require 'rails_helper'

describe 'Weekly stats', type: :request do
  subject { get '/stats/weekly' }

  let(:json_response) { JSON.parse(response.body) }

  it 'returns 200 status code' do
    subject
    expect(response).to have_http_status(200)
  end

  context 'with trips from current week only' do
    let!(:trips) do
      FactoryBot.create_list(:trip, 2)
    end

    it 'returns weekly total distance' do
      subject
      expect(json_response).to include("total_distance" => "1597.52km")
    end
  end

  context 'with trips older that week' do
    let!(:trip) { FactoryBot.create(:trip, created_at: 2.weeks.ago) }
    let!(:trip) { FactoryBot.create(:trip, created_at: 1.month.ago) }
    let!(:trip) { FactoryBot.create(:trip, created_at: 1.year.ago) }

    it 'returns weekly total distance' do
      subject
      expect(json_response).to include("total_distance" => "0.0km")
    end
  end
end