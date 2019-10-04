module API
  class DevicesController < APIController

    def index
      races = Race.where(id: params[:race_ids])
      devices = Device.where(id: races.flat_map(&:devices)).listing.by_kind(params[:kind])

      render json: DeviceSerializer.new(devices)
    end

  end
end
