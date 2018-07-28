class DevicesController < ApplicationController
  before_action :set_device, only: %i[show edit update destroy command reset data_lines]

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
      respond_to do |format|
        format.js
        format.html { redirect_to @device, notice: 'Device was successfully updated.' }
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

  def reset
    @device.reset! unless @device.unregistered?

    redirect_back(fallback_location: root_path, notice: 'Reset successful')
  end

  def data_lines
    render json: BasicDataLineSerializer.new(@device.data_lines)
  end

  def connected
    render partial: 'connected_devices', locals: { devices: Device.connected }
  end

  private

  def set_device
    @device = Device.find(params[:id])
  end

  def device_params
    params.require(:device).permit!
  end
end
