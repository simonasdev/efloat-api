module SpeedExceed::ProcessRace
  module_function

  def run(race)
    ApplicationRecord.transaction do
      race.tracks.limited.each do |track|
        total = Device.all.count
        Device.all.each.with_index do |device, index|
          SpeedExceed::Compact.for(race, track, device)
        end
      end

      race.update(speed_exceed_processed: true)
      puts("Processed race \"##{race.title}\" - #{race.speed_exceed_events.count} speed exceed events!")
    end
  end
end
