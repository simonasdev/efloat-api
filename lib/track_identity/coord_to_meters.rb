# https://social.msdn.microsoft.com/Forums/en-US/5ae71dad-a632-4777-9dad-c6c6e9935953/longtitude-and-latitude-to-cartesian?forum=vbgeneral

# DEPRECATED
module TrackIdentity::CoordToMeters
  module_function

  def go_int(lat, lng)
    y = lat * TrackIdentity::MAGIC
    x = lng * TrackIdentity::MAGIC * Math.cos(lat)

    [x, y].map do |float|
      (float / TrackIdentity::SQUARE_SIZE).to_i
    end
  end

  def go_float(lat, lng)
    y = lat * TrackIdentity::MAGIC
    x = lng * TrackIdentity::MAGIC * Math.cos(lat)

    [x, y].map do |float|
      float / TrackIdentity::SQUARE_SIZE
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
