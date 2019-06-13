class DataLinesController < ApplicationController
  def index
    timestamps = params.values_at(:timestamp_from, :timestamp_until).map(&Time.zone.method(:parse))

    data_lines = DataLine
                  .where(params.permit(:device_id, :race_id))
                  .by_timestamp(*timestamps)
                  .order(:timestamp)

    render json: BasicDataLineSerializer.new(data_lines)
  end
end
