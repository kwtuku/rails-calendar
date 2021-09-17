require 'rails_helper'

RSpec.describe 'Homes', type: :request do
  describe 'GET /' do
    context 'not signed in' do
      it 'returns a 200 response' do
        get root_path
        expect(response).to have_http_status 200
      end
    end

    context 'signed in' do
      let(:alice) { create :user }

      it 'returns a 302 response' do
        sign_in alice
        get root_path
        expect(response).to have_http_status 302
      end

      it 'redirects to new_user_session_path' do
        sign_in alice
        get root_path
        expect(response).to redirect_to events_path
      end
    end
  end
end
