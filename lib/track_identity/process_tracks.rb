module TrackIdentity::ProcessTracks
  module_function

  def run
    Track.limited.each do |track|
      puts("Generating identity for track #{track.name} ##{track.id}...")

      points = TrackIdentity::ProcessCoordinates.new(track.route).run
      points_for_insert = points.map { |point| track.points.new(point.slice(:x, :y)) }

      ApplicationRecord.transaction do
        puts("Persisting identity for track #{track.name} ##{track.id}...")

        track.points.delete_all
        Point.import points_for_insert

        puts("#{track.name} ##{track.id} Done!")
        puts
      end
    end

    TrackIdentity.log_successful_generation
  end
end
