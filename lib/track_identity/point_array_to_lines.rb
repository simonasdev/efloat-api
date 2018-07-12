class TrackIdentity::PointArrayToLines
  attr_reader :point_array

  def initialize(point_array)
    @point_array = point_array
  end

  def run
    point_array.each_cons(2).map { |a, b| [a, b] }
  end
end
