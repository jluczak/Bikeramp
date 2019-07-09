require 'rails_helper'

describe 'Weekly stats', type: :request do
  let!(:trips) do
    FactoryBot.create_list(:trip, 2)
  end

  subject { get "/stats/weekly" }

  it 'returns 200 status code' do
    expect(subject).to have_http_status(200)
  end
end