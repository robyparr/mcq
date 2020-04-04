module YouTube
  class Client
    include HTTParty
    base_uri 'https://www.googleapis.com/youtube/v3'
    headers 'Accept' => 'application/json'

    default_timeout 10

    include YouTube::Videos

    private

    def get(url, params = nil)
      response = self.class.get(url, query: params, format: :plain)
      JSON.parse response, symbolize_names: true
    end

    def access_token
      Rails.application.credentials.youtube[:access_token]
    end

    def default_params
      {
        key: access_token,
      }
    end
  end
end
