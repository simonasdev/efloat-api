namespace :points do
  task calculate: :environment do
    Point.delete_all

    # Track.where(id: 248).each do |track|
    #   points = TrackIdentity::ProcessCoordinates.new(track.route).run

    #   points.each do |point|
    #     Point.create(point.slice(:x, :y).merge(track: track))
    #   end
    # end

    Track.where(id: 248).each do |track|

      points = track.route.map do |coord|
        TrackIdentity::CoordToMeters.go(*coord)
      end.map do |x, y|
        [x, y + 1]
      end

      points.each do |point|
        # Point.create(point.slice(:x, :y).merge(track: track))
        Point.create(x: point[0], y: point[1], track: track)
      end
    end
  end
end
