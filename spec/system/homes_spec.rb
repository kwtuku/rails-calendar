require 'rails_helper'

RSpec.describe 'Homes', type: :system do
  it 'has sign up link and login link' do
    visit root_path
    within '.navbar' do
      expect(page).to have_link href: new_user_session_path
      expect(page).to have_link href: new_user_registration_path
    end
  end
end
