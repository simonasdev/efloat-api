class TrackIdentity::ProcessCoordinates
  attr_reader :coord_array

  def initialize(coord_array)
    @coord_array = coord_array.uniq
  end

  def run
    TrackIdentity::FilteredPoints.new(point_array).run
  end

  private

  def point_array
    coord_array.map do |lat, lng|
      TrackIdentity::CoordToMetersMercator.get(lat, lng)
    end
  end
end
