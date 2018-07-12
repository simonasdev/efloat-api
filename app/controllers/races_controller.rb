class RacesController < ApplicationController
  before_action :set_race, only: [:show, :edit, :update, :destroy, :import_tracks, :watch]

  def index
    @races = Race.all
  end

  def show
  end

  def new
    @race = Race.new
  end

  def edit
  end

  def create
    @race = Race.new(race_params)

    if @race.save
      redirect_to @race, notice: 'Race was successfully created.'
    else
      render :new
    end
  end

  def update
    if @race.update(race_params)
      redirect_to @race, notice: 'Race was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @race.destroy

    redirect_to races_url, notice: 'Race was successfully destroyed.'
  end

  def import_tracks
    Import::Tracks.new(@race, params[:file].tempfile).run!

    redirect_to @race, notice: 'Tracks successfully imported'
  end

  def watch
  end

  def device
    @device = Device.find(params[:device_id])
  end

  private

  def set_race
    @race = Race.find(params[:id])
  end

  def race_params
    params.require(:race).permit!
  end
end
