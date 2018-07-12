# https://social.msdn.microsoft.com/Forums/en-US/5ae71dad-a632-4777-9dad-c6c6e9935953/longtitude-and-latitude-to-cartesian?forum=vbgeneral

module TrackIdentity::CoordToMeters
  module_function

  def go(lng, lat)
    x = lng * TrackIdentity::MAGIC * Math.cos(lat)
    y = lat * TrackIdentity::MAGIC

    [x, y].map(&:to_i)
  end
end
