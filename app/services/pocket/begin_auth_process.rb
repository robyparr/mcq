module Pocket
  class BeginAuthProcess < ApplicationService
    include Rails.application.routes.url_helpers

    attr_reader :redirect_url

    def initialize(user)
      @user = user
    end

    def call
      redirect_token = SecureRandom.uuid
      redirect_url   = authentication_redirect_integrations_url(redirect_token: redirect_token)
      request_token  = generate_request_token(redirect_url)

      create_user_integration_record request_token, redirect_token
      @redirect_url = pocket_client.authentication_url(request_token, redirect_url)
    end

    private

    attr_reader :user

    def pocket_client
      @pocket_client ||= Pocket::Client.new
    end

    def create_user_integration_record(request_token, redirect_token)
      user.integrations.create(
        service: 'Pocket',
        request_token: request_token,
        redirect_token: redirect_token
      )
    end

    def generate_request_token(redirect_url)
      pocket_client.generate_request_token(redirect_url)
    end
  end
end
