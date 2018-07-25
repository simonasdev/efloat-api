module SpeedExceed::ProcessRace
  module_function

  def run(race)
    race.transaction do
      race.speed_exceed_events.delete_all
      events = []

      race.tracks.limited.each do |track|
        Device.all.each.with_index do |device, index|
          events.concat SpeedExceed::Compact.for(race, track, device)
        end
      end

      SpeedExceedEvent.import(events) if events.any?

      race.update(speed_exceed_processed: true)
      puts("Processed race \"##{race.title}\" - #{race.speed_exceed_events.count} speed exceed events!")
    end
  end
end
