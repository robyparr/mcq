class ApplicationController < ActionController::Base
  include Clearance::Controller

  before_action :require_login
  around_action :set_time_zone, if: :current_user

  private

  def redirect_ajax_to(location)
    render json: { status: 303, location: location }
  end

  def redirect_to_media_list(options = {})
    redirect_to media_items_path(queue: params[:queue]), options
  end

  def set_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end
end
