require 'rails_helper'

describe 'monthly stats', type: :request do
  subject { get '/stats/monthly' }

  let(:json_response) { JSON.parse(response.body) }
  let(:current_month) { DateTime.current.strftime('%m') }

  let!(:trip) { FactoryBot.create(:trip, created_at: "2019-#{current_month}-02") }
  let!(:trip2) { FactoryBot.create(:trip, created_at: "2019-#{current_month}-02", distance: "100.0") }
  let!(:trip3) { FactoryBot.create(:trip, created_at: "2019-#{current_month}-27") }
  let!(:trip4) { FactoryBot.create(:trip, created_at: 1.month.ago) }

  it 'returns 200 status code' do
    subject
    expect(response).to have_http_status(200)
  end

  it 'returns only days where trips where made' do
    subject
    expect(json_response[0]).to include({ "day" => "2019-#{current_month}-02" })
    expect(json_response[1]).to include({ "day" => "2019-#{current_month}-27" })
  end

  it 'returns only days from current month' do
    subject
    expect(json_response.count).to eq(2)
  end

  it 'returns total_distance grouped by day' do
    subject
    expect(json_response[0]).to include({ "total_distance" => "898.76" })
    expect(json_response[1]).to include({ "total_distance" => "798.76" })
  end

end