require 'rails_helper'

describe 'monthly stats', type: :request do
  subject { get '/stats/monthly' }

  it 'returns 200 status code' do
    subject
    expect(response).to have_http_status(200)
  end
end