class Point < ApplicationRecord
  belongs_to :track

  def coordinates
    TrackIdentity::CoordToMeters.reverse(x, y)
  end
end
