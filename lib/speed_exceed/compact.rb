class SpeedExceed::Compact
  MAX_SILENCE = 10
  DECAY_RATE = 10 # to glue lines together, (line2.stamp - line1.stamp) >= line1.speed_exceed.to_f / DECAY_RATE

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
    speed_exceed_events.each do |event|
      event.average_speed = event.get_data_lines.average(:speed_exceeded)
    end
  end

  private

  def exceeded_datalines
    @exceeded_datalines ||= SpeedExceedDataLine
      .where(race: race, limited_track: track, device: device)
      .where('speed_exceeded > 0')
      .order(timestamp: :asc).to_a
  end

  def speed_exceed_events
    @speed_exceed_events ||= begin
      events = []

      exceed_time = 0
      event_line_ids = []

      exceeded_datalines.each.with_index do |line, index|
        event_line_ids << line.id

        seconds_to_decay = line.speed_exceeded.to_f / DECAY_RATE
        next_line = exceeded_datalines[index + 1]

        if next_line
          delta_time = next_line.timestamp.to_i - line.timestamp.to_i

          if delta_time > MAX_SILENCE && delta_time > seconds_to_decay # next line is after decay
            events << build_speed_exceed_event(event_line_ids, exceed_time)
            exceed_time = 0
            event_line_ids = []
          else # next line is before decay (same event)
            exceed_time += delta_time
          end
        else # last iteration
          events << build_speed_exceed_event(event_line_ids, exceed_time)
        end
      end

      events
    end
  end

  def build_speed_exceed_event(ids, time)
    SpeedExceedEvent.new(
      race: race,
      track: track,
      device: device,
      data_line_ids: ids,
      seconds: [time, 1].max,
    )
  end
end
