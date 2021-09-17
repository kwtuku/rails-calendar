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

  describe 'guest sign in' do
    it 'signs in as guest user' do
      visit root_path
      click_link 'ゲストログイン'
      expect(page).to have_content 'ゲストユーザーとしてログインしました。'
    end
  end

  describe 'destroy account' do
    let(:alice) { create :user }

    it 'destroys account' do
      sign_in alice
      click_link 'アカウント削除手続き'
      expect(current_path).to eq users_confirm_destroy_path
      fill_in 'user[current_password]', with: alice.password
      expect{
        click_button '削除'
      }.to change { User.count }.by(-1)
      expect(page).to have_content 'アカウントを削除しました。またのご利用をお待ちしております。'
    end
  end
end
