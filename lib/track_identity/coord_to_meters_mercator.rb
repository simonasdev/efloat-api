module TrackIdentity::CoordToMetersMercator
  RADIUS = 6_378_137.0 # of Earth in meters

  module_function

  def get(lat, lng)
    lng_rad = lng / 180.0 * Math::PI
    lat_rad = lat / 180.0 * Math::PI

    x = RADIUS * lng_rad
    y = RADIUS * Math.log((Math.sin(lat_rad) + 1) / Math.cos(lat_rad))

    [x, y].map do |float|
      (float / TrackIdentity::SQUARE_SIZE).to_i
    end
  end

  def reverse(x, y)
    x, y = x.to_f, y.to_f

    x *= TrackIdentity::SQUARE_SIZE
    y *= TrackIdentity::SQUARE_SIZE

    lat_rad = Math.acos(1.0 / (0.5 * (Math::E ** -(y / RADIUS) + Math::E ** (y / RADIUS))))
    lat = lat_rad * 180.0 / Math::PI

    lng_rad = x / RADIUS
    lng = lng_rad * 180.0 / Math::PI

    [lat, lng]
  end
end
