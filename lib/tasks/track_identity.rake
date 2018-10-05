namespace :track_identity do
  task limited_tracks: :environment do
    TrackIdentity::ProcessTracks.run
  end

  task fill_data_lines: :environment do
    race = Race.last
    race.data_lines.where('timestamp > ?', Date.today.beginning_of_day.advance(hours: 8)).preload(:device).find_each do |dataline|
      point = TrackIdentity::CoordToMetersMercator.get(dataline.latitude, dataline.longitude)

      if track = Point.find_by([:x, :y].zip(point).to_h)&.track
        if track.limited?
          speed = [dataline.speed - track.speed_limit, 0].max

          dataline.device.speed_exceed_data_lines.create!(
            dataline.attributes.except('id').merge(speed_exceeded: speed, limited_track: track, race: race)
          ) if speed > 0

          dataline.update_column(:limited_track_id, track.id)
        end
      end
    end
  end
end
