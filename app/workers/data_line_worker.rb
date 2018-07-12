class DataLineWorker
  include Sidekiq::Worker

  ATTRS = %i(timestamp battery_voltage latitude north_south longitude west_east altitude speed orientation sos_count ok_count check)

  def perform identifier, text
    device = Device.find_by(number: identifier)
    values = text.split(',')

    if device && values.size == ATTRS.size
      $redis.set("data_lines:#{device.id}", text)

      attrs = ATTRS.zip(values).to_h

      attrs[:cardinal_direction] = "#{attrs.delete(:north_south)}/#{attrs.delete(:west_east)}"
      attrs[:data] = text
      attrs[:timestamp] = DateTime.strptime(attrs[:timestamp], '%s').in_time_zone

      return if attrs[:timestamp] > Time.current || !valid_coordinate?(attrs[:latitude]) || !valid_coordinate?(attrs[:longitude])

      line = device.data_lines.create(attrs)
      device.update(current_data_line: line)
    end
  end

  def valid_coordinate? coord
    coord.to_d > 0 && coord.to_d <= 180
  end
end
