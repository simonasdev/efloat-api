require 'matrix'

# ONLY WORKS WITH CARTESIAN VALUES
class TrackIdentity::FilteredPoints
  MAX_DIST = 0.003

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
    assigned_points.select do |point|
      point[:distance] <= MAX_DIST
    end
  end

  def assigned_points
    all_points.map.with_index do |point, index|
      p "#{index} done" if index % 100 == 0
      line, distance = closest_line_to([point[:x], point[:y]])

      point[:line] = line
      point[:distance] = distance

      point
    end
  end

  def all_points
    TrackIdentity::PointMatrix.new(point_array).run
  end

  def closest_line_to(point)
    k = TrackIdentity::PointDistanceToSegment.new([], nil)
    lines_with_distances = lines.map do |line|
      [line, k.dist_to_segment(*line, point)]
    end

    lines_with_distances.min_by(&:last)
  end
end
