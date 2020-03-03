module Pocket
  class Client
    include HTTParty
    base_uri 'https://getpocket.com/v3'

    include Pocket::Items

    def initialize(integration = nil)
      @integration = integration
    end

    def generate_request_token(redirect_url)
      response = post '/oauth/request', body: {
        consumer_key: consumer_key,
        redirect_uri: redirect_url,
      }

      response[:code]
    end

    def authentication_url(request_token, redirect_url)
      "https://getpocket.com/auth/authorize?request_token=#{request_token}&redirect_uri=#{redirect_url}"
    end

    def authorize(code)
      post '/oauth/authorize', body: {
        consumer_key: consumer_key,
        code: code,
      }
    end

    private

    def post(url, body:)
      response = self.class.post(url, body: body, headers: default_headers)
      JSON.parse(response.to_json).symbolize_keys
    end

    def consumer_key
      Rails.application.credentials.pocket[:consumer_key]
    end

    def default_headers
      {
        'X-Accept' => 'application/json',
      }
    end

    def default_params
      {
        consumer_key: consumer_key,
        access_token: @integration.auth_token
      }
    end
  end
end
