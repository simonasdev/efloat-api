module DevicesHelper
  def render_connected_devices(devices)
    devices.map { |device| %Q(#{device.position} - #{device.index}, #{$redis.get("data_lines:#{device.id}")}) }.join("\n")
  end

  def render_disconnected_devices(devices)
    devices.map do |device|
      data_line = $redis.get("data_lines:#{device.id}").to_s.split(',').map.with_index do |d, i|
        i.zero? ? DateTime.strptime(d, '%s').in_time_zone : d
      end.join(',')

      %Q(#{device.position} - #{device.index}, #{data_line})
    end.join("\n")
  end
end
