class TrackIdentity::FilteredPoints
  attr_reader :point_array, :lines

  def initialize(point_array)
    @point_array = point_array
    @lines = TrackIdentity::PointArrayToLines.new(point_array).run
  end

  def run
    filtered_points
  end

  private

  def filtered_points
    total = all_points.size

    all_points.select.with_index do |point, index|
      distance_to_track([point[:x], point[:y]]) <= max_distance_adjusted
    end
  end

  def max_distance_adjusted
    @max_distance_adjusted ||= TrackIdentity::MAX_DIST_FROM_TRACK / TrackIdentity::SQUARE_SIZE
  end

  def all_points
    @all_points ||= TrackIdentity::PointMatrix.new(point_array).run
  end

  def distance_to_track(point)
    distances = lines.map do |line|
      TrackIdentity::PointDistanceToLineSegment.get(point, *line)
    end

    distances.min
  end
end
