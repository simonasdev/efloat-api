class SpeedExceedDataLine < ApplicationRecord
  belongs_to :race
  belongs_to :limited_track, class_name: 'Track', optional: true
  belongs_to :device

  scope :ordered, -> { order(:timestamp) }
end
