# https://social.msdn.microsoft.com/Forums/en-US/5ae71dad-a632-4777-9dad-c6c6e9935953/longtitude-and-latitude-to-cartesian?forum=vbgeneral

module TrackIdentity::CoordToMeters
  module_function

  def go(lat, lng)
    x = lng * TrackIdentity::MAGIC * Math.cos(lat)
    y = lat * TrackIdentity::MAGIC

    [x, y].map do |float|
      (float / TrackIdentity::SQUARE_SIZE).to_i
    end
  end

  def reverse(x, y)
    x *= TrackIdentity::SQUARE_SIZE
    y *= TrackIdentity::SQUARE_SIZE

    lat = y / TrackIdentity::MAGIC
    lng = x / TrackIdentity::MAGIC / Math.cos(lat)

    [lat, lng].map(&:to_f)
  end
end
