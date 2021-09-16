require 'rails_helper'

RSpec.describe 'Events', type: :system do
  describe 'show events' do
    let(:alice) { create :user }
    let!(:event) { create :event, start_time: DateTime.now, user: alice }

    it 'shows events' do
      sign_in alice
      visit events_path
      expect(page).to have_content event.name
      expect(page).to have_content I18n.l(event.start_time)
    end
  end

  describe 'show event' do
    let(:alice) { create :user }
    let!(:event) { create :event, start_time: DateTime.now, user: alice }

    it 'shows the event', js: true do
      sign_in alice
      visit events_path
      click_link href: event_path(event)
      expect(page).to have_content event.name
      expect(page).to have_content I18n.l(event.start_time, format: :long)
    end
  end

  describe 'create event' do
    let(:alice) { create :user }
    let(:event) { build_stubbed :event, start_time: DateTime.now }

    it 'creates event', js: true do
      sign_in alice
      visit events_path
      click_button '作成'
      fill_in 'event[name]', with: event.name
      fill_in 'event[start_time]', with: event.start_time
      expect{
        click_button '保存'
      }.to change { Event.count }.by(1)
      .and change { alice.events.count }.by(1)
      expect(page).to have_content '予定を保存しました。'
      expect(page).to have_content event.name
      expect(page).to have_content I18n.l(event.start_time)
    end
  end
end
