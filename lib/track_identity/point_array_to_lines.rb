module TrackIdentity::PointArrayToLines
  module_function

  def get(point_array)
    point_array.each_cons(2).map { |a, b| [a, b] }
  end
end
