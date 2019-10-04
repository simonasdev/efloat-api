class CommandService
  CHANNEL = 'commands'.freeze
  COMMANDS = %w[calibrate check,on check,off zero,ok zero,sos zero,up]

  def initialize(device, command)
    @device, @command = device, command
  end

  def send!
    $redis.publish CHANNEL, {
      identifier: @device.number,
      payload:    @command
    }.to_json
  end
end
