class ApplicationController < ActionController::Base
  include Clearance::Controller

  before_action :require_login

  private

  def bulk_action_redirect_location(fallback:)
    request.referrer || fallback
  end

  def redirect_ajax_to(location)
    render json: { status: 303, location: location }
  end
end
