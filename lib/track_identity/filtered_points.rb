# DEFINED BEHAVIOR ONLY WITH CARTESIAN VALUES

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
      p "#{total} | #{index} done" if index % 100 == 0
      # point_distance_to_line_segment([point[:x], point[:y]]) <= TrackIdentity::MAX_DIST_FROM_TRACK / TrackIdentity::SQUARE_SIZE
      true
    end
  end

  def all_points
    @all_points ||= TrackIdentity::PointMatrix.new(point_array).run
  end

  def point_distance_to_line_segment(point)
    calculator = TrackIdentity::PointDistanceToSegment.new([], nil)

    distances = lines.map do |line|
      calculator.dist_to_segment(*line, point)
    end

    distances.min
  end
end
