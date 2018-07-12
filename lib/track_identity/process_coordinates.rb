require 'matrix'

class TrackIdentity::ProcessCoordinates
  attr_reader :coord_array

  def initialize(coord_array)
    @coord_array = coord_array
  end

  def run
    TrackIdentity::FilteredPoints.new(point_array).run
  end

  private

  def point_array
    coord_array.map do |lat, lng|
      TrackIdentity::CoordToMeters.go(lat, lng)
    end
  end
end
