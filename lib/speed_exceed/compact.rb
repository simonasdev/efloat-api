class SpeedExceed::Compact
  attr_reader :race, :track, :device

  def self.for(race, track, device)
    new(race, track, device).run
  end

  def initialize(race, track, device)
    @race = race
    @track = track
    @device = device
  end

  def run
    SpeedExceedEvent.import(speed_exceed_events) if speed_exceed_events.any?
  end

  private

  def exceeded_datalines
    exceeded_datalines ||= SpeedExceedDataLine
      .where(race_id: race.id, limited_track_id: track.id, device_id: device.id)
      .where('speed_exceeded > 0')
      .order(timestamp: :asc)
  end

  def speed_exceed_events
    @speed_exceed_events ||= begin
      events = []
      event = nil

      last_timestamp = 0

      exceeded_datalines.each do |dataline|
        if dataline.timestamp - last_timestamp <= 1
          last_timestamp = increment_speed_exceed_event(event, dataline)
        else
          events << event if event
          event = build_speed_exceed_event

          last_timestamp = increment_speed_exceed_event(event, dataline)
        end
      end

      events << event
      events
    end
  end

  def build_speed_exceed_event
    SpeedExceedEvent.new(
      race: race,
      track: track,
      device: device,
      data_line_ids: [],
      seconds: 0,
    )
  end

  def increment_speed_exceed_event(event, dataline)
    event.data_line_ids << dataline.id
    event.seconds += 1

    dataline.timestamp
  end
end
