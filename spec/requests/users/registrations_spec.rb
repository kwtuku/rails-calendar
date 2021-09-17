require 'rails_helper'

RSpec.describe 'Users::Registrations', type: :request do
  describe 'GET /users/confirm_destroy' do
    context 'not signed in' do
      it 'returns a 302 response' do
        get users_confirm_destroy_path
        expect(response).to have_http_status 302
      end

      it 'redirects to new_user_session_path' do
        get users_confirm_destroy_path
        expect(response).to redirect_to new_user_session_path
      end

      it 'shows a flash message' do
        get users_confirm_destroy_path
        expect(flash[:alert]).to eq 'アカウント登録もしくはログインしてください。'
      end
    end

    context 'signed in' do
      let(:alice) { create :user }

      it 'returns a 200 response' do
        sign_in alice
        get users_confirm_destroy_path
        expect(response).to have_http_status 200
      end
    end
  end

  describe 'DELETE /users' do
    context 'not signed in' do
      it 'returns a 302 response' do
        delete user_registration_path
        expect(response).to have_http_status 302
      end

      it 'redirects to new_user_session_path' do
        delete user_registration_path
        expect(response).to redirect_to new_user_session_path
      end

      it 'does not decrease user count' do
        expect {
          delete user_registration_path
        }.to change { User.count }.by(0)
      end
    end

    context 'signed in' do
      let(:alice) { create :user }

      context 'with wrong password' do
        it 'returns a 200 response' do
          sign_in alice
          delete user_registration_path(alice), params: { user: { current_password: 'wrong_password' } }
          expect(response).to have_http_status 200
        end

        it 'does not decrease user count' do
          sign_in alice
          expect{
            delete user_registration_path, params: { user: { current_password: 'wrong_password' } }
          }.to change { User.count }.by(0)
        end

        it 'shows a error message' do
          sign_in alice
          delete user_registration_path, params: { user: { current_password: 'wrong_password' } }
          expect(response.body).to include '現在のパスワードは不正な値です'
        end
      end

      context 'with right password' do
        it 'returns a 302 response' do
          sign_in alice
          delete user_registration_path, params: { user: { current_password: alice.password } }
          expect(response).to have_http_status 302
        end

        it 'redirects to root_path' do
          sign_in alice
          delete user_registration_path, params: { user: { current_password: alice.password } }
          expect(response).to redirect_to root_path
        end

        it 'decreases user count' do
          sign_in alice
          expect{
            delete user_registration_path, params: { user: { current_password: alice.password } }
          }.to change { User.count }.by(-1)
        end
      end
    end
  end
end
