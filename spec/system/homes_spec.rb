require 'rails_helper'

RSpec.describe 'Homes', type: :system do
  it 'GET /' do
    visit root_path
    within('h1') do
      expect(page).to have_content 'Home#index'
    end
    within('p') do
      expect(page).to_not have_content 'Home#index'
    end
  end
end
