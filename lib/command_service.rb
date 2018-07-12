class CommandService
  CHANNEL = 'commands'.freeze

  def initialize device, command
    @device, @command = device, command
  end

  def send!
    $redis.publish CHANNEL, {
      identifier: @device.number,
      payload:    @command
    }.to_json
  end
end
