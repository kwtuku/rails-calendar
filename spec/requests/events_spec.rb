require 'rails_helper'

RSpec.describe 'Events', type: :request do
  describe 'GET /events' do
    context 'not signed in' do
      it 'returns a 302 response' do
        get events_path
        expect(response).to have_http_status 302
      end

      it 'redirects to new_user_session_path' do
        get events_path
        expect(response).to redirect_to new_user_session_path
      end

      it 'shows a flash message' do
        get events_path
        expect(flash[:alert]).to eq 'アカウント登録もしくはログインしてください。'
      end
    end

    context 'signed in' do
      let(:alice) { create :user }
      let!(:event) { create :event, start_time: DateTime.now, user: alice }

      it 'returns a 200 response' do
        sign_in alice
        get events_path
        expect(response).to have_http_status 200
      end

      it 'renders events' do
        sign_in alice
        get events_path
        expect(response.body).to include event.name
      end
    end
  end

  describe 'POST /events' do
    context 'not signed in' do
      it 'returns a 302 response' do
        event_params = attributes_for(:event)
        post events_path, params: { event: event_params }
        expect(response).to have_http_status 302
      end

      it 'redirects to new_user_session_path' do
        event_params = attributes_for(:event)
        post events_path, params: { event: event_params }
        expect(response).to redirect_to new_user_session_path
      end

      it 'shows a flash message' do
        event_params = attributes_for(:event)
        post events_path, params: { event: event_params }
        expect(flash[:alert]).to eq 'アカウント登録もしくはログインしてください。'
      end

      it 'does not increase event count' do
        event_params = attributes_for(:event)
        expect {
          post events_path, params: { event: event_params }
        }.to change { Event.count }.by(0)
      end
    end

    context 'signed in' do
      let(:alice) { create :user }

      it 'returns a 302 response' do
        sign_in alice
        event_params = attributes_for(:event, user: alice)
        post events_path, params: { event: event_params }
        expect(response).to have_http_status 302
      end

      it 'redirects to events_path' do
        sign_in alice
        event_params = attributes_for(:event, user: alice)
        post events_path, params: { event: event_params }
        expect(response).to have_http_status 302
      end

      it 'shows a flash message' do
        sign_in alice
        event_params = attributes_for(:event, user: alice)
        post events_path, params: { event: event_params }
        expect(flash[:notice]).to eq '予定を保存しました。'
      end

      it 'increases event count' do
        sign_in alice
        event_params = attributes_for(:event, user: alice)
        expect {
          post events_path, params: { event: event_params }
        }.to change { Event.count }.by(1)
        .and change { alice.events.count }.by(1)
      end
    end
  end
end
