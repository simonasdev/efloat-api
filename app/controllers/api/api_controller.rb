module API
  class APIController < ApplicationController
    skip_before_action :authenticate_user!
    protect_from_forgery with: :null_session
  end
end
