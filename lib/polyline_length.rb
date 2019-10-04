require 'geo/coord'

class PolylineLength
  def self.for(polyline)
    new(polyline).run
  end

  def initialize(polyline)
    @polyline = polyline
  end

  def run
    sum = 0.0

    @polyline.each_with_index do |position, index|
      next unless previous_position = @polyline[index - 1]

      sum += Geo::Coord.new(*previous_position).distance(Geo::Coord.new(*position))
    end

    sum
  end
end
