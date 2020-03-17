require 'rails_helper'

RSpec.describe Pocket::BeginAuthProcess do
  before do
    allow_any_instance_of(Pocket::Client)
      .to receive(:consumer_key).and_return('fake-key')
  end

  describe '.call' do
    let(:user) { create :user }

    let(:redirect_token) { SecureRandom.uuid }
    let(:request_token) { 'request-token' }

    let!(:generate_request_token_request) do
      stub_request(:post, 'https://getpocket.com/v3/oauth/request')
         .to_return(status: 200, body: { code: request_token }.to_json)
    end

    before do
      allow(SecureRandom).to receive(:uuid).and_return(redirect_token)
    end

    it do
      begin_auth_process = nil
      expect { begin_auth_process = described_class.call user }
        .to change(user.integrations, :count).from(0).to(1)

      created_integration = user.integrations.first
      expect(created_integration).to have_attributes(
        service: 'Pocket',
        redirect_token: redirect_token,
        request_token: request_token,
      )

      expect(generate_request_token_request).to have_been_made.once
      expect(
        begin_auth_process.redirect_url.start_with?('https://getpocket.com/auth/authorize')
      ).to eq(true)
    end
  end
end
