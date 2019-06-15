class DriversController < ApplicationController
  before_action :set_driver, only: %i[show edit update destroy watch]

  def index
    @q = Driver.ransack(params[:q])
    @drivers = @q.result
  end

  def show
  end

  def new
    @driver = Driver.new
  end

  def edit
  end

  def create
    @driver = Driver.new(driver_params)

    if @driver.save
      redirect_to @driver, notice: 'Driver was successfully created.'
    else
      render :new
    end
  end

  def update
    if @driver.update(driver_params)
      respond_to do |format|
        format.js
        format.html { redirect_to @driver, notice: 'Driver was successfully updated' }
      end
    else
      render :edit
    end
  end

  def destroy
    @driver.destroy

    redirect_to drivers_url, notice: 'Driver was successfully destroyed.'
  end

  def watch
    @race = Race.find(params[:race_id])
  end

  private

  def set_driver
    @driver = Driver.find(params[:id])
  end

  def driver_params
    params.require(:driver).permit!
  end
end
