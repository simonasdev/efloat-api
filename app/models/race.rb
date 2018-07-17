class Race < ApplicationRecord
  has_many :tracks, -> { order(:id) }
  has_many :speed_exceed_events

  scope :current, -> { where('start_time < :now AND end_time > :now', now: Time.current).preload(:tracks) }
  scope :speed_exceed_unprocessed, -> { where(speed_exceed_processed: false) }

  def devices
    Device.enabled
  end
end
