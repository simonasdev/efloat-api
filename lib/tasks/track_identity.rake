namespace :track_identity do
  task limited_tracks: :environment do
    TrackIdentity::ProcessTracks.run
  end
end
