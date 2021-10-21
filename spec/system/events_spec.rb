require 'rails_helper'

RSpec.describe 'Events', type: :system do
  describe 'show events' do
    let(:alice) { create :user }
    let!(:event) { create :event, start_time: DateTime.now, end_time: DateTime.now + 10.seconds, user: alice }

    it 'shows events' do
      sign_in alice
      visit events_path
      expect(page).to have_content event.name
      expect(page).to have_content I18n.l(event.start_time)
    end
  end

  describe 'show event' do
    let(:alice) { create :user }
    let!(:event) { create :event, start_time: DateTime.now, end_time: DateTime.now + 10.seconds, user: alice }

    it 'shows the event', js: true do
      sign_in alice
      visit events_path
      click_link href: event_path(event)
      expect(page).to have_content event.name
      expect(page).to have_content "#{I18n.l(event.start_time, format: :long)}~#{I18n.l(event.end_time)}"
      expect(page).to have_content event.description
    end
  end

  describe 'create event' do
    let(:alice) { create :user }
    let(:event) { build_stubbed :event, start_time: DateTime.now, end_time: DateTime.now + 10.seconds }

    it 'creates event', js: true do
      sign_in alice
      visit events_path
      click_button '作成'
      fill_in 'event[name]', with: event.name
      fill_in 'event[start_time]', with: event.start_time
      fill_in 'event[end_time]', with: event.end_time
      fill_in 'event[description]', with: event.description
      expect{
        click_button '保存'
      }.to change { Event.count }.by(1)
      .and change { alice.events.count }.by(1)
      expect(page).to have_content '予定を保存しました。'
      expect(page).to have_content event.name
      expect(page).to have_content I18n.l(event.start_time)
    end
  end

  describe 'update event' do
    let(:alice) { create :user }
    let!(:event) { create :event, start_time: DateTime.now, end_time: DateTime.now + 10.seconds, user: alice }

    it 'updates event', js: true do
      old_event_name = event.name
      sign_in alice
      visit events_path
      click_link href: event_path(event)
      click_link href: edit_event_path(event)
      expect(page).to have_content old_event_name
      fill_in 'event[name]', with: 'new event name'
      click_button '更新'
      expect(page).to have_content '予定を更新しました。'
      expect(event.reload.name).to_not eq old_event_name
    end
  end

  describe 'destroy event' do
    let(:alice) { create :user }
    let!(:event) { create :event, start_time: DateTime.now, end_time: DateTime.now + 10.seconds, user: alice }

    it 'creates event', js: true do
      expect(alice.events.count).to eq 1
      sign_in alice
      visit events_path
      click_link href: event_path(event)
      destroy_link = find('.rspec_destroy_event')
      destroy_link.click
      page.accept_confirm
      expect(page).to have_content '予定を削除しました。'
      expect(alice.events.count).to eq 0
    end
  end

  describe 'duplicate event' do
    let(:alice) { create :user }
    let!(:original_event) { create :event, start_time: DateTime.now, end_time: DateTime.now + 10.seconds, user: alice }

    it 'duplicates event', js: true do
      original_event_name = original_event.name
      expect(alice.events.count).to eq 1
      sign_in alice
      visit events_path
      click_link href: event_path(original_event)
      click_link href: duplicate_event_path(original_event)
      expect(page).to have_content original_event_name
      fill_in 'event[name]', with: 'not original event name'
      fill_in 'event[start_time]', with: DateTime.now
      fill_in 'event[end_time]', with: DateTime.now + 10.seconds
      click_button '保存'
      expect(page).to have_content '予定を保存しました。'
      expect(alice.events.count).to eq 2
      expect(original_event.reload.name).to eq original_event_name
    end
  end
end
