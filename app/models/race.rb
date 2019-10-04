class Race < ApplicationRecord
  has_many :tracks, -> { order(:id) }
  has_many :speed_exceed_events, dependent: :destroy
  has_many :markers, dependent: :destroy
  has_many :data_lines

  accepts_nested_attributes_for :tracks

  scope :current, -> { where('start_time < :now AND end_time > :now', now: Time.current).preload(:tracks) }
  scope :speed_exceed_unprocessed, -> { where(speed_exceed_processed: false) }
  scope :ordered, -> { order(start_time: :desc) }

  after_commit :notify_changes, on: :update, if: :saved_change_to_public?

  def devices
    Device.not_disabled
  end

  private

  def notify_changes
    $redis.publish(Device::CHANNEL, RaceSerializer.new(self).to_json)
  end
end
