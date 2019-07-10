require 'rails_helper'

RSpec.describe 'Trip destruction', type: :request do
  it 'has a valid factory' do
    expect(FactoryBot.create(:trip)).to be_valid
  end

  let!(:trip) do
    FactoryBot.create(:trip)
  end

  let(:trip_destroy) { delete "/trips/#{trip.id}" }

  it 'destroys a trip and returns 204 status code' do
    expect { trip_destroy }.to change { Trip.count }.by(-1)
    expect(response).to have_http_status(204)
  end
end
