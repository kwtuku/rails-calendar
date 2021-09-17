require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /users/sign_in' do
    it 'returns a 200 response' do
      get new_user_session_path
      expect(response).to have_http_status 200
    end
  end

  describe 'POST /users/sign_in' do
    let(:alice) { create :user }

    it 'returns a 302 response' do
      user_params = { :email=>alice.email, :password=>alice.password }
      post user_session_path, params: { user: user_params }
      expect(response).to have_http_status 302
    end

    it 'signs in' do
      user_params = { :email=>alice.email, :password=>alice.password }
      post user_session_path, params: { user: user_params }
      expect(controller.current_user).to eq alice
    end
  end

  describe 'GET /users/sign_up' do
    it 'returns a 200 response' do
      get new_user_registration_path
      expect(response).to have_http_status 200
    end
  end

  describe 'POST /users/sign_up' do
    it 'returns a 302 response' do
      user_params = attributes_for(:user)
      post user_registration_path, params: { user: user_params }
      expect(response).to have_http_status 302
    end

    it 'increases user count' do
      user_params = attributes_for(:user)
      expect {
        post user_registration_path, params: { user: user_params }
      }.to change { User.count }.by(1)
    end
  end
end
