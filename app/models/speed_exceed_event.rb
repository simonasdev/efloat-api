class SpeedExceedEvent < ApplicationRecord
  belongs_to :race
  belongs_to :track
  belongs_to :device

  def get_data_lines
    SpeedExceedDataLine.where(id: data_line_ids)
  end
end
