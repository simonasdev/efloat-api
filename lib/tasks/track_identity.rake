namespace :track_identity do
  task limited_tracks: :environment do
    TrackIdentity::ProcessTracks.run
  end

  task fill_data_lines: :environment do
    Race.last.data_lines.where('timestamp < ?', Time.current.beginning_of_hour).preload(:device).each do |dataline|
      point = TrackIdentity::CoordToMetersMercator.get(dataline.latitude, dataline.longitude)

      if track = Point.find_by([:x, :y].zip(point).to_h)&.track
        if track.limited?
          speed = [dataline.speed - track.speed_limit, 0].max

          dataline.device.speed_exceed_data_lines.create!(
            dataline.attributes.except('id').merge(speed_exceeded: speed)
          ) if speed > 0

          dataline.update_column(:limited_track_id, track.id)
        end
      end
    end
  end
end
