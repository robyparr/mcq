class IntegrationsController < ApplicationController
  layout 'settings'

  def index
    @integrations = current_user.integrations.completed
  end

  def new
    begin_auth_process = Pocket::BeginAuthProcess.call(current_user)
    redirect_to begin_auth_process.redirect_url
  end

  def authentication_redirect
    Pocket::FinishAuthProcess.call params[:redirect_token]
    redirect_to integrations_path
  end

  def synchronize
    pull_items = Pocket::PullItems.call(current_user, params[:integration_id])

    flash[:notice] = "Pulled #{pull_items.pulled_item_count} items from Pocket."
    redirect_to media_items_path
  end
end
