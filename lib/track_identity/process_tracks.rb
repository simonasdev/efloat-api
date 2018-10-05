module TrackIdentity::ProcessTracks
  module_function

  def run(tracks = Track.limited, force: false)
    unless force || TrackIdentity.current_data_stale?
      puts("Track identities up to date, skipping")
      return
    end

    # Clear identity cache

    ApplicationRecord.transaction do
      Point.where(track_id: tracks).delete_all

      tracks.order(:id).each(&method(:process_track))
    end

    # Fill identity cache

    TrackIdentity.log_successful_generation
  end

  def points_for_insert(track)
    points = TrackIdentity::ProcessCoordinates.new(track.route).run

    points.map { |point| track.points.new(x: point[0], y: point[1]) }
  end

  def process_track(track)
    puts("Generating identity for track #{track.name} ##{track.id}...")

    points = points_for_insert(track)
    Point.import points

    puts("#{track.name} ID##{track.id} done with #{points.size} points!")
    puts
  end
end
