class Race < ApplicationRecord
  has_many :tracks, -> { order(:id) }
  has_many :speed_exceed_events, dependent: :destroy
  has_many :markers, dependent: :destroy
  has_many :data_lines

  scope :current, -> { where('start_time < :now AND end_time > :now', now: Time.current).preload(:tracks) }
  scope :speed_exceed_unprocessed, -> { where(speed_exceed_processed: false) }
  scope :ordered, -> { order(:start_time) }

  def devices
    Device.not_disabled
  end
end
