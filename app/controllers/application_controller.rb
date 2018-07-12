class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  layout 'application'

  private

  def json_request?
    request.format.json?
  end
end
