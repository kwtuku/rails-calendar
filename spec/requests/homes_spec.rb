require 'rails_helper'

RSpec.describe 'Homes', type: :request do
  describe 'GET /' do
    it 'returns a 200 response' do
      get root_path
      expect(response).to have_http_status 200
    end

    it 'renders Home#index' do
      get root_path
      expect(response.body).to include 'Home#index'
    end
  end
end
