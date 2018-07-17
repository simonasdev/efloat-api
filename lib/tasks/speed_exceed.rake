namespace :speed_exceed do
  task process: :environment do
    Race.speed_exceed_unprocessed.each do |race|
      SpeedExceed::ProcessRace.run(race)
    end
  end
end
