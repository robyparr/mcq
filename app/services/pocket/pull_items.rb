module Pocket
  class PullItems < ApplicationService
    attr_reader :pulled_item_count

    def initialize(user, integration_id)
      @user = user
      @integration_id = integration_id
    end

    def call
      if pocket_client.hit_rate_limit?
        @pulled_item_count = 0
        return
      end

      pocket_integration.with_log(:pull_items) do
        pulled_pocket_item_ids = []

        pocket_client.items.each do |item|
          media_item = build_media_item_from_pocket_item item
          media_item.estimate_consumption_difficulty!

          if media_item.save
            pulled_pocket_item_ids.push item[:id]
          end
        end

        @pulled_item_count = pulled_pocket_item_ids.count
        archive_and_tag_pocket_items pulled_pocket_item_ids

        true
      end
    end

    private

    attr_reader :user,
                :integration_id

    def pocket_client
      @pocket_client ||= Pocket::Client.new(pocket_integration.auth_token)
    end

    def pocket_integration
      @pocket_integration ||= user.integrations.find(integration_id)
    end

    def build_media_item_from_pocket_item(pocket_item)
      attrs = media_item_attrs(pocket_item).merge(queue: user.inbox_queue)
      user.media_items.build attrs
    end

    def media_item_attrs(pocket_item)
      {
        title: pocket_item[:title],
        url: pocket_item[:url],
        estimated_consumption_time: pocket_item[:time_to_read],
        service_id: pocket_item[:id],
        service_type: 'Pocket',
      }
    end

    def archive_and_tag_pocket_items(pocket_item_ids)
      return unless pocket_item_ids.present?

      pocket_client.archive_and_tag_items pocket_item_ids, 'mcq-pulled'
    end
  end
end
