require 'rails_helper'

RSpec.describe 'Users', type: :system do
  describe 'sign in' do
    let(:alice) { create :user }

    it 'signs in' do
      visit new_user_session_path
      fill_in 'user[email]', with: alice.email
      fill_in 'user[password]', with: alice.password
      click_button 'ログイン'
      expect(page).to have_content 'ログインしました。'
    end
  end

  describe 'sign up' do
    let(:alice) { build_stubbed :user }

    it 'signs up' do
      visit new_user_registration_path
      fill_in 'user[email]', with: alice.email
      fill_in 'user[password]', with: alice.password
      fill_in 'user[password_confirmation]', with: alice.password_confirmation
      expect{ click_button 'アカウント登録' }.to change { User.count }.by(1)
      expect(page).to have_content 'アカウント登録が完了しました。'
    end
  end
end
