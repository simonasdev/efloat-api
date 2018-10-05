class ProcessTracksWorker
  include Sidekiq::Worker

  def perform(race_id)
    TrackIdentity::ProcessTracks.run(Race.find(race_id).tracks.limited, force: true)
  end
end
