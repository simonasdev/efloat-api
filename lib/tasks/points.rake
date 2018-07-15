namespace :generate_points do
  task limited_tracks: :environment do
    TrackIdentity::ProcessTracks.run
  end
end
