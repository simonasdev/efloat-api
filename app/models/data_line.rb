class DataLine < ApplicationRecord
  BATTERY_VOLTAGES = (3..4.2)

  belongs_to :device, touch: true
  belongs_to :race, optional: true
  belongs_to :limited_track, class_name: 'Track', optional: true

  scope :ordered, -> { order(:device_id, timestamp: :desc, id: :desc) }
  scope :by_timestamp, ->(from, till) { where('data_lines.timestamp BETWEEN ? AND ?', from, till) }

  def name
    device.name
  end

  def battery_percentage
    min = BATTERY_VOLTAGES.begin

    [((battery_voltage - min) / (BATTERY_VOLTAGES.end - min) * 100).round(1), 100].min
  end
end
