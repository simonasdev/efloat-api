class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  layout 'application'

  private

  def invalidate_cache
    response.headers['Cache-Control'] = 'no-cache, no-store, max-age=0, must-revalidate'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = 'Fri, 01 Jan 1990 00:00:00 GMT'
  end

  def json_request?
    request.format.json?
  end
end
