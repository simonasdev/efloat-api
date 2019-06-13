class RacesController < ApplicationController
  before_action :set_race, only: %i[show edit update destroy import_tracks import_markers watch speed_report import_limited_tracks]

  def index
    @races = Race.ordered
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

  def import_limited_tracks
    Import::Tracks.new(@race, params[:file].tempfile, limited: true).run!

    redirect_to @race, notice: 'Tracks successfully imported'
  end

  def import_tracks
    Import::Tracks.new(@race, params[:file].tempfile).run!

    redirect_to @race, notice: 'Tracks successfully imported'
  end

  def import_markers
    Import::Markers.new(@race, params[:file].tempfile).run!

    redirect_to @race, notice: 'Markers successfully imported'
  end

  def watch
  end

  def device
    @device = Device.find(params[:device_id])
  end

  def speed_report
    SpeedExceed::ProcessRace.run(@race) unless @race.speed_exceed_processed?

    if speed_report_params.values.all?(&:present?)
      timestamp_from, timestamp_until, speed, time = speed_report_params.values

      response.headers['Content-Disposition'] = "inline; filename=#{@race.title} report #{time}-#{speed}.xlsx"

      @events = @race.speed_exceed_events
                     .with_lines_by_range(timestamp_from, timestamp_until)
                     .where('average_speed >= ? AND seconds >= ?', speed, time)
                     .preload(:device, :track)
    else
      flash[:error] = 'Fill all inputs'
      redirect_back(fallback_location: race_path(@race))
    end
  end

  private

  def speed_report_params
    params.permit(:timestamp_from, :timestamp_until, :speed, :time)
  end

  def set_race
    @race = Race.find(params[:id])
  end

  def race_params
    params.require(:race).permit!
  end
end
