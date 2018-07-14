class FloatPoint < ApplicationRecord
  belongs_to :track

  def coordinate
    TrackIdentity::CoordToMetersMercator.reverse(x, y)
  end
end
