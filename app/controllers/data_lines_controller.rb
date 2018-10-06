class DataLinesController < ApplicationController
  def index
    data_lines = DataLine.where(params.permit(:device_id, :race_id))

    render json: BasicDataLineSerializer.new(data_lines)
  end
end
