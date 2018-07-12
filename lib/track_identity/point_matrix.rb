class TrackIdentity::PointMatrix
  ROUND_AMOUNT = 3
  PADDING = 0.0003

  attr_reader :point_array

  def initialize(point_array)
    @point_array = point_array
  end

  def run
    point_matrix
  end

  def expected_amount
    (bounds[:min_x]..bounds[:max_x]).step(step_size).to_a.count * (bounds[:min_y]..bounds[:max_y]).step(step_size).to_a.count
  end

  private

  def bounds
    @bounds ||= begin
      transposed = point_array.transpose

      min_x, max_x = transposed[0].min, transposed[0].max
      min_y, max_y = transposed[1].min, transposed[1].max

      min_x, max_x = min_x - PADDING, max_x + PADDING
      min_y, max_y = min_y - PADDING, max_y + PADDING

      {
        min_x: min_x.round(ROUND_AMOUNT).to_d,
        max_x: max_x.round(ROUND_AMOUNT).to_d,
        min_y: min_y.round(ROUND_AMOUNT).to_d,
        max_y: max_y.round(ROUND_AMOUNT).to_d,
      }
    end
  end

  def point_matrix
    matrix = []

    (bounds[:min_x]..bounds[:max_x]).step(step_size).each do |x|
      (bounds[:min_y]..bounds[:max_y]).step(step_size).each do |y|
        matrix << { x: x, y: y }
      end
    end

    matrix
  end

  def step_size
    zeros = '0' * (ROUND_AMOUNT - 1)

    "0.#{zeros}1".to_d
  end

end
