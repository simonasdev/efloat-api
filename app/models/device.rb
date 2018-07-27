class Device < ApplicationRecord
  include AASM

  NOTIFIABLE_ATTRIBUTES = %i[current_data_line_id online state]

  CHANNEL = 'messages'.freeze

  aasm column: :state do
    state :enabled, initial: true
    state :disabled
    state :technical
    state :retired
  end

  store_accessor :crew_data, :car, :country

  enum kind: %i[driver security ambulance other]

  has_many :data_lines, dependent: :delete_all
  has_many :speed_exceed_data_lines
  belongs_to :current_data_line, class_name: 'DataLine', optional: true

  scope :listing, -> {
    order(Arel.sql(%q(
      CASE WHEN left(devices.position, 1) = '0' THEN 1 ELSE 0 END ASC,
      CASE WHEN devices.position ~ '^\d+$' THEN devices.position::integer ELSE NULL END ASC NULLS LAST
    ))).preload(:current_data_line)
  }
  scope :online, -> { where(online: true) }
  scope :offline, -> { where(online: false) }
  scope :by_kind, ->(*_kinds) { where(kind: _kinds) }

  after_commit :notify_changes, on: :update, if: -> { saved_changes.values_at(*NOTIFIABLE_ATTRIBUTES).any?(&:present?) }

  def offline?
    !online
  end

  def self.connected
    numbers = $redis.get('devices:connected')

    numbers ? where(number: JSON.parse(numbers)).order('index::integer') : none
  end

  private

  def notify_changes
    $redis.publish CHANNEL, DeviceSerializer.new(self).to_json
  end
end
