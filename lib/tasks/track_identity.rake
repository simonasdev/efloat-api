namespace :track_identity do
  task limited_tracks: :environment do
    break p 'processing'
    TrackIdentity::ProcessTracks.run
  end

  task fill_data_lines: :environment do
    total = DataLine.count

    DataLine.find_each.with_index do |dataline, index|
      p("#{total} | #{index}") if index % 1000 == 0

      coord_id = TrackIdentity::CoordToMetersMercator.get(dataline.latitude, dataline.longitude)
      track_id = Point.find_by(x: coord_id[0], y: coord_id[1])&.track_id

      next unless track_id

      dataline.update_column(:limited_track_id, track_id)
    end
  end
end
