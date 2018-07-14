namespace :points do
  task int: :environment do
    Point.delete_all

    Track.where(id: TrackIdentity::BEST_TRACK_ID).each do |track|
      points = TrackIdentity::ProcessCoordinates.new(track.route).run

      points.each do |point|
        Point.create(point.slice(:x, :y).merge(track: track))
      end
    end
  end

  task float: :environment do
    FloatPoint.delete_all

    # test conversion
    Track.where(id: TrackIdentity::BEST_TRACK_ID).each do |track|
      points = TrackIdentity::ProcessCoordinates.new(track.route).run

      points.each do |point|
        FloatPoint.create(point.slice(:x, :y).merge(track: track))
      end
    end
  end
end
