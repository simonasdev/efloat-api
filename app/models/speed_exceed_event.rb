class SpeedExceedEvent < ApplicationRecord
  belongs_to :race
  belongs_to :track
  belongs_to :device

  scope :joined_lines, -> { joins('INNER JOIN speed_exceed_data_lines lines ON lines.id = ANY(speed_exceed_events.data_line_ids)') }
  scope :ordered, -> { order(:track_id) }

  def self.with_lines_by_range(from, till)
    joined_lines.group(:id)
      .having("MIN(lines.timestamp) > #{connection.quote(from)} AND MAX(lines.timestamp) < #{connection.quote(till)}")
  end

  def get_data_lines
    SpeedExceedDataLine.where(id: data_line_ids)
  end
end
