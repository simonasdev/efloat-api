module TrackIdentity::PointDistanceToPoint
  module_function

  def get(point_a, point_b)
    distance(
      point_a.map(&:to_f),
      point_b.map(&:to_f),
    )
  end

  def distance(pa, pb)
    Math.sqrt((pa[0] - pb[0]) ** 2 + (pa[1] - pb[1]) ** 2)
  end
end
