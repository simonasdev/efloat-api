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
      next if index.zero?

      sum += Geo::Coord.new(*@polyline[index - 1]).distance(Geo::Coord.new(*position))
    end

    sum
  end
end
