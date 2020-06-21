class ApplicationController < ActionController::Base
  include Clearance::Controller

  before_action :require_login
  around_action :set_time_zone, if: :current_user

  private

  def bulk_action_redirect_location(fallback:)
    request.referrer || fallback
  end

  def redirect_ajax_to(location)
    render json: { status: 303, location: location }
  end

  def redirect_to_media_list(options = {})
    path =
      if params[:queue].present?
        queue_path(params[:queue])
      else
        media_items_path
      end

    redirect_to path, options
  end

  def set_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end
end
