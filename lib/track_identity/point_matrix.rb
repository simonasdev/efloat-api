class TrackIdentity::PointMatrix
  attr_reader :point_array

  def initialize(point_array)
    @point_array = point_array
  end

  def run
    point_matrix
  end

  private

  def bounds
    @bounds ||= begin
      transposed = point_array.transpose

      min_x, max_x = transposed[0].min, transposed[0].max
      min_y, max_y = transposed[1].min, transposed[1].max

      min_x, max_x = min_x - 100, max_x + 100
      min_y, max_y = min_y - 100, max_y + 100

      {
        min_x: min_x,
        max_x: max_x,
        min_y: min_y,
        max_y: max_y,
      }
    end
  end

  def point_matrix
    matrix = []

    (bounds[:min_x]..bounds[:max_x]).step(TrackIdentity::SQUARE_SIZE).each do |x|
      (bounds[:min_y]..bounds[:max_y]).step(TrackIdentity::SQUARE_SIZE).each do |y|
        matrix << { x: x, y: y }
      end
    end

    matrix
  end

end
