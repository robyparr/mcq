class IntegrationsController < ApplicationController
  layout 'settings'

  def index
    @integrations = current_user.integrations.completed
  end

  def new
    redirect_token = SecureRandom.uuid
    redirect_url = authentication_redirect_integrations_url(redirect_token: redirect_token)
    request_token = integration_client.generate_request_token(redirect_url)

    current_user.integrations.create(
      service: params[:service],
      request_token: request_token,
      redirect_token: redirect_token
    )

    redirect_to integration_client.authentication_url(request_token, redirect_url)
  end

  def authentication_redirect
    integration = Integration.find_by!(
      redirect_token: params[:redirect_token],
      created_at: 5.minutes.ago...Time.current
    )
    response = integration_client(service: integration.service).authorize(integration.request_token)

    integration_attrs = auth_params_for_integration(integration.service, response).merge(
      redirect_token: nil,
      request_token: nil
    )

    integration.update integration_attrs
    redirect_to integrations_path
  end

  def synchronize
    integration = current_user.integrations.find(params[:integration_id])
    items = integration_client(integration: integration).items

    inbox_queue = current_user.queues.find_or_initialize_by(name: 'Inbox') do |queue|
      queue.color = '#eee'
    end
    inbox_queue.save unless inbox_queue.persisted?

    items.each do |item|
      current_user.media_items.create(
        queue: inbox_queue,
        title: item[:given_title] || item[:resolved_title],
        url: item[:given_url],
        estimated_consumption_time: item[:time_to_read],
      )
    end

    redirect_to media_items_path
  end

  private

  def integration_client(service: nil, integration: nil)
    service ||= integration.try(:service) || params[:service]
    @integration_client ||=
      case service
      when 'Pocket' then Pocket::Client.new(integration)
      else
        raise "Unsupported service #{service}"
      end
  end

  def auth_params_for_integration(service, response)
    case service
    when 'Pocket'
      {
        auth_token: response[:access_token],
        username: response[:username],
      }
    else
      raise "Unsupported service #{service}"
    end
  end
end
