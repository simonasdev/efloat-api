class DataLineWorker
  include Sidekiq::Worker

  ATTRS = %i(timestamp battery_voltage latitude north_south longitude west_east altitude speed orientation sos_count ok_count check)

  def perform identifier, text
    device = Device.find_by(number: identifier)
    values = text.split(',')

    if device && values.size == ATTRS.size
      $redis.set("data_lines:#{device.id}", text)

      attrs = ATTRS.zip(values).to_h

      attrs[:race_id] = Race.current.first&.id

      attrs[:cardinal_direction] = "#{attrs.delete(:north_south)}/#{attrs.delete(:west_east)}"
      attrs[:data] = text
      attrs[:timestamp] = DateTime.strptime(attrs[:timestamp], '%s').in_time_zone

      lat, lng = attrs.values_at(:latitude, :longitude).map(&:to_d)
      return if attrs[:timestamp] > Time.current || !valid_coordinate?(lat) || !valid_coordinate?(lng)

      point = TrackIdentity::CoordToMetersMercator.get(lat, lng)
      if track = Point.find_by([:x, :y].zip(point).to_h)&.track
        attrs[:limited_track_id] = track.id
        Rails.logger.info "found point, track - #{track.id}"
        if track.limited?
          speed = [attrs[:speed].to_i - track.speed_limit, 0].max

          Rails.logger.info "speed - #{speed}"
          SpeedExceedDataLine.create(attrs.merge(speed_exceeded: speed)) if speed > 0
        end
      end

      line = device.data_lines.create(attrs)
      device.update(current_data_line: line, online: true)
    end
  end

  def valid_coordinate? coord
    coord > 0 && coord <= 180
  end
end
