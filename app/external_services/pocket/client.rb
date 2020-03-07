module Pocket
  class Client
    include HTTParty
    base_uri 'https://getpocket.com/v3'
    headers 'X-Accept' => 'application/json'

    default_timeout 10

    include Pocket::Items

    RATE_LIMIT_THRESHOLD = 100
    EXPECTED_RATE_LIMIT  = 10_000

    def initialize(auth_token = nil)
      @auth_token = auth_token

      @@rate_limit = EXPECTED_RATE_LIMIT
      @@remaining_rate_limit = [@@rate_limit, Time.current]
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

    def hit_rate_limit?
      remaining_rate_limit <= RATE_LIMIT_THRESHOLD
    end

    private

    attr_reader :auth_token

    def post(url, body:)
      return if hit_rate_limit?

      response = self.class.post(url, body: body, format: :plain)
      update_remaining_rate_limit response.headers

      JSON.parse response, symbolize_names: true
    end

    def consumer_key
      Rails.application.credentials.pocket[:consumer_key]
    end

    def default_params
      {
        consumer_key: consumer_key,
        access_token: auth_token,
      }
    end

    def update_remaining_rate_limit(headers)
      limit            = headers['x-limit-key-limit'].to_i
      remaining_limit  = headers['x-limit-key-remaining'].to_i
      secs_until_reset = headers['x-limit-key-reset'].to_i

      time_until_reset = Time.current + secs_until_reset.seconds

      @@rate_limit = limit
      @@remaining_rate_limit = [remaining_limit, time_until_reset]
    end

    def remaining_rate_limit
      remaining, expiry = @@remaining_rate_limit

      if expiry.past?
        @@rate_limit
      else
        remaining
      end
    end
  end
end
