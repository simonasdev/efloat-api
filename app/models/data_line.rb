class DataLine < ApplicationRecord
  BATTERY_VOLTAGES = (3.15..4.2)

  belongs_to :device, touch: true
  belongs_to :race
  belongs_to :limited_track, class_name: 'Track'

  scope :ordered, -> { order(:device_id, timestamp: :desc, id: :desc) }

  def name
    device.name
  end

  def battery_percentage
    min = BATTERY_VOLTAGES.begin

    ((battery_voltage - min) / (BATTERY_VOLTAGES.end - min) * 100).round(1)
  end
end
