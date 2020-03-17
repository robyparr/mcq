require 'rails_helper'

RSpec.describe Pocket::FinishAuthProcess do
  before do
    allow_any_instance_of(Pocket::Client)
      .to receive(:consumer_key).and_return('fake-key')
  end

  describe '::REDIRECT_TOKEN_EXPIRY_LENGTH' do
    it do
      expect(described_class::REDIRECT_TOKEN_EXPIRY_LENGTH).to eq(5.minutes)
    end
  end

  describe '.call' do
    let!(:user) { create :user }
    let!(:incomplete_integration) do
      create :integration,
             :pocket,
             user: user,
             redirect_token: redirect_token,
             request_token: request_token
    end

    let(:redirect_token) { 'redirect-token' }
    let(:request_token)  { 'request-token' }

    let(:auth_response_body) do
      {
        access_token: 'access-token',
        username: 'user123',
      }
    end

    let!(:generate_request_token_request) do
      stub_request(:post, 'https://getpocket.com/v3/oauth/authorize')
        .to_return(status: 200, body: auth_response_body.to_json)
    end

    it 'completes the ingration process' do
      described_class.call redirect_token

      expect(incomplete_integration.reload).to have_attributes(
        redirect_token: nil,
        request_token: nil,
        auth_token: auth_response_body[:access_token],
        username: auth_response_body[:username],
      )

      expect(generate_request_token_request).to have_been_made.once
    end

    context 'with expired incomplete integration record' do
      it 'raises an exception' do
        incomplete_integration.update created_at: 6.minutes.ago

        expect { described_class.call redirect_token }
          .to raise_error(ActiveRecord::RecordNotFound)

        expect(incomplete_integration.reload).to have_attributes(
          redirect_token: redirect_token,
          request_token: request_token,
          auth_token: nil,
          username: nil,
        )
      end
    end
  end
end
