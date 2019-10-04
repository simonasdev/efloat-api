module API
  class RacesController < APIController
    RELATIONSHIPS = %i(tracks markers)

    def index
      @races = Race.current

      render json: FullRaceSerializer.new(@races, params: { kind: params[:kind] }, include: RELATIONSHIPS)
    end
  end
end
