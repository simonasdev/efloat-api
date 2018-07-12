# https://social.msdn.microsoft.com/Forums/en-US/5ae71dad-a632-4777-9dad-c6c6e9935953/longtitude-and-latitude-to-cartesian?forum=vbgeneral

module TrackIdentity::MetersToCoord
  module_function

  def go(x, y)
    lat = y / TrackIdentity::MAGIC
    lng = x / TrackIdentity::MAGIC / Math.cos(lat)

    [lng, lat].map(&:to_f)
  end
end
