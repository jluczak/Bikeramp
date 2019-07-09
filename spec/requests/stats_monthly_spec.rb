require 'rails_helper'

describe 'monthly stats', type: :request do
  subject { get '/stats/monthly' }

  let(:json_response) { JSON.parse(response.body) }

  it 'returns 200 status code' do
    subject
    expect(response).to have_http_status(200)
  end

  context 'with trips from current month only' do
    let!(:trips) do
      FactoryBot.create_list(:trip, 2)
    end
    let(:today) { Date.today }

    it 'returns all days from current month where trips where made' do
      subject
      expect(json_response).to include("day" => "#{today.strftime("%B, #{today.day.ordinalize}")}")
    end
  end
end