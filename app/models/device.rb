class Device < ApplicationRecord
  include AASM

  NOTIFIABLE_ATTRIBUTES = %i[current_data_line_id online state]

  CHANNEL = 'messages'.freeze

  aasm column: :state do
    state :enabled, initial: true
    state :disabled
    state :hidden
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
  scope :not_disabled, -> { where.not(state: :disabled) }
  scope :online, -> { where(online: true) }
  scope :offline, -> { where(online: false) }
  scope :by_kind, ->(*_kinds) { where(kind: _kinds) }
  scope :ordered, -> { order(Arel.sql('index::integer')) }

  after_commit :notify_changes, on: :update, if: -> { saved_changes.values_at(*NOTIFIABLE_ATTRIBUTES).any?(&:present?) }
  before_save :set_comment_presence

  def races
    Race.where(id: data_lines.select(:race_id))
  end

  def offline?
    !online
  end

  def self.connected
    numbers = $redis.get('devices:connected')

    numbers ? where(number: JSON.parse(numbers)).ordered : none
  end

  private

  def notify_changes
    $redis.publish CHANNEL, DeviceSerializer.new(self).to_json
  end

  def set_comment_presence
    self.comment = comment.presence
  end
end
