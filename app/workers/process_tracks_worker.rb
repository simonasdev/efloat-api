class ProcessTracksWorker
  include Sidekiq::Worker

  def perform(race_id)
    TrackIdentity::ProcessTracks.run(force: true, Race.find(race_id).tracks.limited)
  end
end
