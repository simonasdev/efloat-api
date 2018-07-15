class TrackIdentity::PointMatrix
  attr_reader :point_array

  def initialize(point_array)
    @point_array = point_array
  end

  def run
    puts("Generating #{matrix_size} points...")
    point_matrix
  end

  def matrix_size
    (bounds[:max_x] - bounds[:min_x] + 1) * (bounds[:max_y] - bounds[:min_y] + 1)
  end

  private

  def bounds
    @bounds ||= begin
      transposed = point_array.transpose

      min_x, max_x = transposed[0].min, transposed[0].max
      min_y, max_y = transposed[1].min, transposed[1].max

      padding = TrackIdentity::MAX_DIST_FROM_TRACK / TrackIdentity::SQUARE_SIZE * 2

      min_x, max_x = min_x - padding, max_x + padding
      min_y, max_y = min_y - padding, max_y + padding

      {
        min_x: min_x.to_i,
        max_x: max_x.to_i,
        min_y: min_y.to_i,
        max_y: max_y.to_i,
      }
    end
  end

  def point_matrix
    (bounds[:min_x]..bounds[:max_x]).flat_map do |x|
      (bounds[:min_y]..bounds[:max_y]).map do |y|
        [x, y]
      end
    end
  end
end
