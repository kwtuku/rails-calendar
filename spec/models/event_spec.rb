require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'validations' do
    it { is_expected.to validate_length_of(:name).is_at_most(255) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:start_time) }
    it { is_expected.to validate_presence_of(:end_time) }

    describe 'time_validation' do
      context 'start_time > end_time' do
        it 'is invalid' do
          set_start_time = DateTime.new(2021, 1, 1, 12)
          set_end_time = set_start_time - 1.hour

          event = build_stubbed(:event, start_time: set_start_time, end_time: set_end_time)
          expect(event.valid?).to eq false
        end

        it 'has error message' do
          set_start_time = DateTime.new(2021, 1, 1, 12)
          set_end_time = set_start_time - 1.hour

          event = build_stubbed(:event, start_time: set_start_time, end_time: set_end_time)
          event.valid?
          expect(event.errors[:end_time]).to include 'は開始時刻以降の時間を入力してください'
        end
      end

      context 'start_time == end_time' do
        it 'is valid' do
          set_start_time = DateTime.new(2021, 1, 1, 12)
          set_end_time = set_start_time

          event = build_stubbed(:event, start_time: set_start_time, end_time: set_end_time)
          expect(event.valid?).to eq true
        end
      end

      context 'start_time < end_time' do
        it 'is valid' do
          set_start_time = DateTime.new(2021, 1, 1, 12)
          set_end_time = set_start_time + 1.hour

          event = build_stubbed(:event, start_time: set_start_time, end_time: set_end_time)
          expect(event.valid?).to eq true
        end
      end
    end
  end
end
