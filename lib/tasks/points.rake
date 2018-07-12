namespace :points do
  task calculate: :environment do
    Point.delete_all

    Track.where(id: 248).each do |track|
      points = TrackIdentity::ProcessCoordinates.new(track.route).run

      points.each do |point|
        Point.create(point.slice(:x, :y).merge(track: track))
      end
    end
  end
end
