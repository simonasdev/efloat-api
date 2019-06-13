class DataLinesController < ApplicationController
  def index
    data_lines = DataLine
                  .where(params.permit(:device_id, :race_id))
                  .by_timestamp(*params.values_at(:timestamp_from, :timestamp_until))
                  .order(:timestamp)
    Rails.logger.info data_lines.to_sql
    render json: BasicDataLineSerializer.new(data_lines)
  end
end
