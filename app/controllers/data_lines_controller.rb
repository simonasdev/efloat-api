class DataLinesController < ApplicationController
  def index
    data_lines = DataLine
                  .where(params.permit(:device_id, :race_id))
                  .where('timestamp BETWEEN ? AND ?', *params.values_at(:timestamp_from, :timestamp_until))
                  .order(:timestamp)

    render json: BasicDataLineSerializer.new(data_lines)
  end
end
