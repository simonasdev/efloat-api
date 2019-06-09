class DataLinesController < ApplicationController
  def index
    data_lines = DataLine.where(params.permit(:device_id, :race_id)).limit(1000)

    render json: BasicDataLineSerializer.new(data_lines)
  end
end
