module TrackIdentity
  # how much leeway we give to the GPS data
  MAX_DIST_FROM_TRACK = 50.to_f # meters
  # how fine-grained the grid is
  SQUARE_SIZE = 20.to_f # meters
  # WARNING: changing above contants warrants reprocessing of all tracks!

  LOG_PATH = 'log/track_identity.log'.freeze

  module_function

  def log_successful_generation
    File.write(LOG_PATH, self_identity.to_json)
  end

  def self_identity
    {
      'MAX_DIST_FROM_TRACK' => MAX_DIST_FROM_TRACK,
      'SQUARE_SIZE' => SQUARE_SIZE
    }
  end

  def current_data_stale?
    Dir[LOG_PATH].blank? || JSON.parse(File.read(LOG_PATH)) != self_identity
  end
end
