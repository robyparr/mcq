module Pocket
  class FinishAuthProcess < ApplicationService
    REDIRECT_TOKEN_EXPIRY_LENGTH = 5.minutes

    def initialize(redirect_token)
      @redirect_token = redirect_token
    end

    def call
      integration = find_integration_by_token!
      authorize_response = pocket_client.authorize(integration.request_token)

      integration.update(
        auth_token: authorize_response[:access_token],
        username: authorize_response[:username],
        redirect_token: nil,
        request_token: nil,
      )
    end

    private

    attr_reader :redirect_token

    def pocket_client
      @pocket_client ||= Pocket::Client.new
    end

    def find_integration_by_token!
      Integration.find_by!(
        redirect_token: redirect_token,
        created_at: REDIRECT_TOKEN_EXPIRY_LENGTH.ago...Time.current
      )
    end
  end
end
