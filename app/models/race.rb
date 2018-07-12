class Race < ApplicationRecord
  has_many :tracks, -> { order(:id) }

  scope :current, -> { where('start_time < :now AND end_time > :now', now: Time.current).preload(:tracks) }

  def devices
    Device.enabled
  end
end
