require 'rails_helper'

RSpec.describe 'Trip destruction', type: :request do
  it 'has a valid factory' do
    expect(FactoryBot.create(:trip)).to be_valid
  end

  let!(:trip) do
    FactoryBot.create(:trip, FactoryBot.attributes_for(:trip))
  end

  let(:trip_destroy) { delete "/trips/#{trip.id}" }

  it 'it returns 204' do
    trip_destroy
    expect(response).to have_http_status(204)
  end

  it 'destroys a trip' do
    expect { trip_destroy }.to change { Trip.count }.by(-1)
  end
end
