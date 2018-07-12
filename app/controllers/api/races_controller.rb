module API
  class RacesController < APIController

    def index
      @races = Race.current

      render json: RaceSerializer.new(@races, params: { kind: params[:kind] }, include: %i(tracks))
    end

  end
end
