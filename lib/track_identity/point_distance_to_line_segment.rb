module TrackIdentity::PointDistanceToLineSegment
  module_function

  def get(point, line_point_a, line_point_b)
    dist_to_segment(point, line_point_a, line_point_b)
  end

  def distance_squared(lpa, lpb)
    (lpa[0] - lpb[0]) ** 2 + (lpa[1] - lpb[1]) ** 2
  end

  def dist_to_segment_squared(point, lpa, lpb)
    line_length = distance_squared(lpa, lpb)

    return distance_squared(point, lpa) if (line_length == 0)

    theta = ((point[0] - lpa[0]) * (lpb[0] - lpa[0]) + (point[1] - lpa[1]) * (lpb[1] - lpa[1])) / line_length
    theta = [0, [1, theta].min].max

    closest_x = lpa[0] + theta * (lpb[0] - lpa[0])
    closest_y = lpa[1] + theta * (lpb[1] - lpa[1])

    distance_squared(point, [closest_x, closest_y])
  end

  def dist_to_segment(point, lpa, lpb)
    Math.sqrt(dist_to_segment_squared(point, lpa, lpb))
  end
end
