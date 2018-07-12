class DeviceStatusWorker
  include Sidekiq::Worker

  def perform identifier, online
    device = Device.find_by(number: identifier)

    if device
      device.update online: online
    end
  end
end
