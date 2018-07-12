class TrackIdentity::PointDistanceToSegment
  attr_reader :lpa, :lpb, :point

  def initialize(line, point)
    @lpa = line[0]
    @lpb = line[1]
    @point = point
  end

  def run
    dist_to_segment(lpa, lpb, point)
  end

  def distance_squared(lpa, lpb)
    (lpa[0] - lpb[0]) ** 2 + (lpa[1] - lpb[1]) ** 2
  end

  def dist_to_segment_squared(lpa, lpb, point)
    l2 = distance_squared(lpa, lpb)

    return distance_squared(point, lpa) if (l2 == 0)

    t = ((point[0] - lpa[0]) * (lpb[0] - lpa[0]) + (point[1] - lpa[1]) * (lpb[1] - lpa[1])) / l2
    t = [0, [1, t].min].max

    some_x = lpa[0] + t * (lpb[0] - lpa[0])
    some_y = lpa[1] + t * (lpb[1] - lpa[1])

    distance_squared(point, [some_x, some_y])
  end

  def dist_to_segment(lpa, lpb, point)
    Math.sqrt(dist_to_segment_squared(lpa, lpb, point))
  end
end
