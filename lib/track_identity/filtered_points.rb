class TrackIdentity::FilteredPoints
  attr_reader :point_array, :lines

  def initialize(point_array)
    @point_array = point_array
    @lines = TrackIdentity::PointArrayToLines.get(point_array)
  end

  def run
    filtered_points
  end

  private

  def filtered_points
    total = all_points.size

    all_points.select do |point|
      distance_to_track(point) <= max_distance_adjusted &&
      distance_to_boundary(point) > max_distance_adjusted
    end
  end

  def max_distance_adjusted
    @max_distance_adjusted ||= TrackIdentity::MAX_DIST_FROM_TRACK / TrackIdentity::SQUARE_SIZE
  end

  def all_points
    @all_points ||= TrackIdentity::PointMatrix.new(point_array).run
  end

  def boundary_points
    @boundary_points ||= [point_array.first, point_array.last]
  end

  def distance_to_boundary(point)
    distances = boundary_points.map do |boundary_point|
      TrackIdentity::PointDistanceToPoint.get(boundary_point, point)
    end

    distances.min
  end

  def distance_to_track(point)
    distances = lines.map do |line|
      TrackIdentity::PointDistanceToLineSegment.get(point, *line)
    end

    distances.min
  end
end
