class DevicesController < ApplicationController
  before_action :invalidate_cache, only: %i(index)
  before_action :set_device, only: %i[show edit update destroy command watch]

  skip_before_action :authenticate_user!, only: %i(index), if: :json_request?

  def index
    @q = Device.ransack(params[:q])
    @devices = @q.result.listing
  end

  def show
  end

  def new
    @device = Device.new
  end

  def edit
  end

  def create
    @device = Device.new(device_params)

    if @device.save
      redirect_to @device, notice: 'Device was successfully created.'
    else
      render :new
    end
  end

  def update
    if @device.update(device_params)
      @notice = device_params[:state].present? ? "State changed to #{@device.state}" : 'Device was successfully updated'

      respond_to do |format|
        format.js
        format.html { redirect_to @device, notice: @notice }
      end
    else
      render :edit
    end
  end

  def destroy
    @device.destroy

    redirect_to devices_url, notice: 'Device was successfully destroyed.'
  end

  def command
    command = params[:value]

    CommandService.new(@device, command).send!

    @notice = "Command sent: #{ command }"
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path, notice: @notice) }
      format.js
    end
  end

  def mass_command
    command = params[:value]

    Device.all.each do |device|
      CommandService.new(device, command).send!
    end

    redirect_back(fallback_location: devices_path, notice: "Command sent to all devices: #{ command }")
  end

  def mass_state_change
    state = params[:value]

    Device.update_all state: state

    redirect_back(fallback_location: devices_path, notice: "State changed of all devices to #{ state }")
  end

  def connected
    devices = Device.connected(params[:sort])

    render partial: 'connected_devices', locals: {
      devices: devices,
      disconnected_devices: Device.enabled.where.not(id: devices.map(&:id)).ordered_by(params[:sort])
    }
  end

  def import
    Import::Devices.new(params[:file].tempfile).run!

    redirect_back(fallback_location: devices_path, notice: 'Device data successfuly imported')
  end

  def watch
    @race = Race.find(params[:race_id])
  end

  private

  def set_device
    @device = Device.find(params[:id])
  end

  def device_params
    params.require(:device).permit!
  end
end
