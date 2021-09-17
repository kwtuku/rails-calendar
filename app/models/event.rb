class Event < ApplicationRecord
  belongs_to :user

  validates :name, length: { maximum: 255 }, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :time_validation

  def time_validation
    if start_time.blank?
      errors.add(:start_time, 'を入力してください')
    elsif end_time.blank?
      errors.add(:end_time, 'を入力してください')
    elsif start_time > end_time
      errors.add(:end_time, 'は開始時刻以降の時間を入力してください')
    end
  end
end
