module API
  class DevicesController < APIController

    def index
      devices = Device.where(id: Race.find(params[:race_ids]).flat_map(&:devices)).listing.by_kind(params[:kind])

      render json: DeviceSerializer.new(devices)
    end

  end
end
