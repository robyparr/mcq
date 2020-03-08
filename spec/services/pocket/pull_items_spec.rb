require 'rails_helper'

RSpec.describe Pocket::PullItems do
  describe '.call' do
    let!(:user) { create :user }
    let!(:integration) { create :integration, :pocket, user: user }

    let(:pocket_items) do
      [
        {
          item_id: '123',
          given_url: 'https://example.com/1',
          given_title: 'example 1',
        },
        {
          item_id: '456',
          given_url: 'https://example.com/2',
          given_title: 'example 2',
        }
      ]
    end

    let(:items_response_body) do
      {
        list: pocket_items.inject({}) do |hash, item|
          key = item[:item_id]
          hash[key] = item

          hash
        end
      }
    end

    let!(:get_items_request) do
      stub_request(:post, 'https://getpocket.com/v3/get')
        .to_return(status: 200, body: items_response_body.to_json)
    end

    let!(:archive_and_tag_items_request) do
      stub_request(:post, 'https://getpocket.com/v3/send')
        .to_return(status: 200, body: {}.to_json)
    end

    before do
      allow_any_instance_of(Pocket::Client).to receive(:hit_rate_limit?).and_return false
    end

    it 'completes the ingration process' do
      pull_items = nil
      expect { pull_items = described_class.call(user, integration.id) }
        .to change(user.media_items, :count).from(0).to(pocket_items.count)
        .and change(ActivityLog, :count).from(0).to(pocket_items.count + 1)

      expect(pull_items.pulled_item_count).to eq(pocket_items.count)

      user.media_items.each do |media_item|
        pocket_item = pocket_items.find { |item| item[:item_id] == media_item.service_id }
        expect(media_item).to have_attributes(
          title: pocket_item[:given_title],
          url: pocket_item[:given_url],
          service_type: 'Pocket',
          service_id: pocket_item[:item_id]
        )
      end

      expect(ActivityLog.pluck(:action).uniq).to match_array(%w[pull_items create])

      expect(get_items_request).to have_been_made.once
      expect(archive_and_tag_items_request).to have_been_made.once
    end
  end
end
