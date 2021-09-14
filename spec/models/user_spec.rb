require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_length_of(:password).is_at_least(6) }
  end

  describe 'self.guest' do
    context 'guest exists' do
      let!(:guest) { create :user, email: 'guest@example.com' }

      it 'is valid' do
        expect(User.guest.valid?).to eq true
      end
    end

    context 'guest dose not exist' do
      it 'is valid' do
        expect(User.guest.valid?).to eq true
      end

      it 'creates guest' do
        expect{
          User.guest
        }.to change { User.count }.by(1)
      end
    end
  end
end
