module TrackIdentity
  # how much leeway we give to the GPS data in meters away from the track
  MAX_DIST_FROM_TRACK = 50.to_f
  # how fine-grained the grid is in meters
  SQUARE_SIZE = 10.to_f
  # to force recalc without changing stuff that matters
  VERSION = 2
  # WARNING: changing above constants warrants reprocessing of all tracks!

  LOG_PATH = 'log/track_identity.log'.freeze

  module_function

  def log_successful_generation
    File.write(LOG_PATH, self_identity)
  end

  def self_identity
    "#{MAX_DIST_FROM_TRACK}|#{SQUARE_SIZE}|#{VERSION}"
  end

  def current_data_stale?
    Dir[LOG_PATH].blank? || File.read(LOG_PATH) != self_identity
  end
end
