class ProcessTracksWorker
  include Sidekiq::Worker

  def perform
    TrackIdentity::ProcessTracks.run(force: true)
  end
end
