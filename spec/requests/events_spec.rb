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
      let!(:event) { create :event, start_time: DateTime.now, end_time: DateTime.now + 1.hour, user: alice }

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
        expect(response).to redirect_to events_path
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

  describe 'GET /events/:id' do
    let(:alice) { create :user }
    let(:bob) { create :user }
    let!(:event) { create :event, start_time: DateTime.now, end_time: DateTime.now + 1.hour, user: alice }

    context 'not signed in' do
      it 'returns a 401 response' do
        get event_path(event), xhr: true
        expect(response).to have_http_status 401
      end

      it 'does not show the event' do
        get event_path(event), xhr: true
        expect(response.body).to_not include event.name
        expect(response.body).to_not include I18n.l(event.start_time, format: :long)
      end
    end

    context 'signed in' do
      context 'as not correct user' do
        it 'returns a 401 response' do
          sign_in bob
          get event_path(event), xhr: true
          expect(response).to have_http_status 401
        end

        it 'shows a flash message' do
          sign_in bob
          get event_path(event), xhr: true
          expect(flash[:alert]).to eq '権限がありません。'
        end

        it 'does not show the event' do
          sign_in bob
          get event_path(event), xhr: true
          expect(response.body).to_not include event.name
          expect(response.body).to_not include I18n.l(event.start_time, format: :long)
        end
      end

      context 'as correct user' do
        it 'returns a 200 response' do
          sign_in alice
          get event_path(event), xhr: true
          expect(response).to have_http_status 200
        end

        it 'shows the event' do
          sign_in alice
          get event_path(event), xhr: true
          expect(response.body).to include event.name
          expect(response.body).to include I18n.l(event.start_time, format: :long)
        end
      end
    end
  end

  describe 'GET /events/:id/edit' do
    let(:alice) { create :user }
    let(:bob) { create :user }
    let!(:event) { create :event, start_time: DateTime.now, end_time: DateTime.now + 1.hour, user: alice }

    context 'not signed in' do
      it 'returns a 401 response' do
        get edit_event_path(event), xhr: true
        expect(response).to have_http_status 401
      end

      it 'shows a flash message' do
        get edit_event_path(event), xhr: true
        expect(response.body).to eq 'アカウント登録もしくはログインしてください。'
      end

      it 'does not show event' do
        get edit_event_path(event), xhr: true
        expect(response.body).to_not include event.name
        expect(response.body).to_not include I18n.l(event.start_time, format: :input_value)
      end
    end

    context 'signed in' do
      context 'as not correct user' do
        it 'returns a 401 response' do
          sign_in bob
          get edit_event_path(event), xhr: true
          expect(response).to have_http_status 401
        end

        it 'shows a flash message' do
          sign_in bob
          get edit_event_path(event), xhr: true
          expect(flash[:alert]).to eq '権限がありません。'
        end

        it 'does not show event' do
          sign_in bob
          get edit_event_path(event), xhr: true
          expect(response.body).to_not include event.name
          expect(response.body).to_not include I18n.l(event.start_time, format: :input_value)
        end
      end

      context 'as correct user' do
        it 'returns a 200 response' do
          sign_in alice
          get edit_event_path(event), xhr: true
          expect(response).to have_http_status 200
        end

        it 'shows form' do
          sign_in alice
          get edit_event_path(event), xhr: true
          expect(response.body).to include 'events-form-modal'
        end

        it 'shows event' do
          sign_in alice
          get edit_event_path(event), xhr: true
          expect(response.body).to include event.name
          expect(response.body).to include I18n.l(event.start_time, format: :input_value)
        end
      end
    end
  end

  describe 'PUT /events/:id' do
    let(:alice) { create :user }
    let(:bob) { create :user }
    let!(:event) { create :event, start_time: DateTime.now, end_time: DateTime.now + 1.hour, user: alice }

    context 'not signed in' do
      it 'returns a 401 response' do
        event_params = attributes_for(:event)
        put event_path(event), params: { event: event_params }, xhr: true
        expect(response).to have_http_status 401
      end

      it 'shows a flash message' do
        event_params = attributes_for(:event)
        put event_path(event), params: { event: event_params }, xhr: true
        expect(response.body).to eq 'アカウント登録もしくはログインしてください。'
      end

      it 'does not update the event' do
        old_event_name = event.name
        old_event_start_time = event.start_time.to_s
        event_params = attributes_for(:event)
        put event_path(event), params: { event: event_params }, xhr: true
        expect(event.reload.name).to eq old_event_name
        expect(event.reload.start_time.to_s).to eq old_event_start_time
      end
    end

    context 'signed in' do
      context 'as not correct user' do
        it 'returns a 200 response' do
          sign_in bob
          event_params = attributes_for(:event)
          put event_path(event), params: { event: event_params }, xhr: true
          expect(response).to have_http_status 200
        end

        it 'shows a flash message' do
          sign_in bob
          event_params = attributes_for(:event)
          put event_path(event), params: { event: event_params }, xhr: true
          expect(flash[:alert]).to eq '権限がありません。'
        end

        it 'does not update the event' do
          old_event_name = event.name
          old_event_start_time = event.start_time.to_s
          sign_in bob
          event_params = attributes_for(:event)
          put event_path(event), params: { event: event_params }, xhr: true
          expect(event.reload.name).to eq old_event_name
          expect(event.reload.start_time.to_s).to eq old_event_start_time
        end
      end

      context 'as correct user' do
        context 'with invalid attributes' do
          it 'returns a 200 response' do
            sign_in alice
            invalid_event_params = attributes_for(:event, name: '', start_time: '')
            put event_path(event), params: { event: invalid_event_params }, xhr: true
            expect(response).to have_http_status 200
          end

          it 'shows error messages' do
            sign_in alice
            invalid_event_params = attributes_for(:event, name: '', start_time: '')
            put event_path(event), params: { event: invalid_event_params }, xhr: true
            expect(response.body).to include '名前を入力してください'
            expect(response.body).to include '開始時刻を入力してください'
          end

          it 'does not update the event' do
            old_event_name = event.name
            old_event_start_time = event.start_time.to_s
            sign_in alice
            invalid_event_params = attributes_for(:event, name: '', start_time: '')
            put event_path(event), params: { event: invalid_event_params }, xhr: true
            expect(event.reload.name).to eq old_event_name
            expect(event.reload.start_time.to_s).to eq old_event_start_time
          end
        end

        context 'with valid attributes' do
          it 'returns a 200 response' do
            sign_in alice
            event_params = attributes_for(:event)
            put event_path(event), params: { event: event_params }, xhr: true
            expect(response).to have_http_status 200
          end

          it 'redirects to events_path' do
            sign_in alice
            event_params = attributes_for(:event)
            put event_path(event), params: { event: event_params }, xhr: true
            expect(response).to redirect_to events_path
          end

          it 'updates the event' do
            old_event_name = event.name
            old_event_start_time = event.start_time.to_s
            sign_in alice
            event_params = attributes_for(:event)
            put event_path(event), params: { event: event_params }, xhr: true
            expect(event.reload.name).to_not eq old_event_name
            expect(event.reload.start_time.to_s).to_not eq old_event_start_time
          end
        end
      end
    end
  end

  describe 'DELETE /events/:id' do
    let(:alice) { create :user }
    let(:bob) { create :user }
    let!(:event) { create :event, start_time: DateTime.now, end_time: DateTime.now + 1.hour, user: alice }

    context 'not signed in' do
      it 'returns a 302 response' do
        delete event_path(event)
        expect(response).to have_http_status 302
      end

      it 'redirects to new_user_session_path' do
        delete event_path(event)
        expect(response).to redirect_to new_user_session_path
      end

      it 'shows a flash message' do
        delete event_path(event)
        expect(flash[:alert]).to eq 'アカウント登録もしくはログインしてください。'
      end

      it 'does not decrease event count' do
        expect {
          delete event_path(event)
        }.to change { Event.count }.by(0)
        .and change { alice.events.count }.by(0)
      end
    end

    context 'signed in' do
      context 'as not correct user' do
        it 'returns a 401 response' do
          sign_in bob
          delete event_path(event)
          expect(response).to have_http_status 401
        end

        it 'shows a flash message' do
          sign_in bob
          get event_path(event), xhr: true
          expect(flash[:alert]).to eq '権限がありません。'
        end

        it 'does not decrease event count' do
          sign_in bob
          expect {
            delete event_path(event)
          }.to change { Event.count }.by(0)
          .and change { alice.events.count }.by(0)
        end
      end

      context 'as correct user' do
        it 'returns a 302 response' do
          sign_in alice
          delete event_path(event)
          expect(response).to have_http_status 302
        end

        it 'redirects to events_path' do
          sign_in alice
          delete event_path(event)
          expect(response).to redirect_to events_path
        end

        it 'decreases event count' do
          sign_in alice
          expect {
            delete event_path(event)
          }.to change { Event.count }.by(-1)
          .and change { alice.events.count }.by(-1)
        end
      end
    end
  end

  describe 'GET /events/:id/duplicate' do
    let(:alice) { create :user }
    let(:bob) { create :user }
    let!(:event) { create :event, start_time: DateTime.now, end_time: DateTime.now + 1.hour, user: alice }

    context 'not signed in' do
      it 'returns a 401 response' do
        get duplicate_event_path(event), xhr: true
        expect(response).to have_http_status 401
      end

      it 'shows a flash message' do
        get duplicate_event_path(event), xhr: true
        expect(response.body).to eq 'アカウント登録もしくはログインしてください。'
      end

      it 'does not show event' do
        get duplicate_event_path(event), xhr: true
        expect(response.body).to_not include event.name
        expect(response.body).to_not include I18n.l(event.start_time, format: :input_value)
      end
    end

    context 'signed in' do
      context 'as not correct user' do
        it 'returns a 401 response' do
          sign_in bob
          get duplicate_event_path(event), xhr: true
          expect(response).to have_http_status 401
        end

        it 'shows a flash message' do
          sign_in bob
          get duplicate_event_path(event), xhr: true
          expect(flash[:alert]).to eq '権限がありません。'
        end

        it 'does not show event' do
          sign_in bob
          get duplicate_event_path(event), xhr: true
          expect(response.body).to_not include event.name
          expect(response.body).to_not include I18n.l(event.start_time, format: :input_value)
        end
      end

      context 'as correct user' do
        it 'returns a 200 response' do
          sign_in alice
          get duplicate_event_path(event), xhr: true
          expect(response).to have_http_status 200
        end

        it 'shows form' do
          sign_in alice
          get duplicate_event_path(event), xhr: true
          expect(response.body).to include 'events-form-modal'
        end

        it 'shows event' do
          sign_in alice
          get duplicate_event_path(event), xhr: true
          expect(response.body).to include event.name
          expect(response.body).to include I18n.l(event.start_time, format: :input_value)
        end
      end
    end
  end
end
