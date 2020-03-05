module Pocket
  class PullItems < ApplicationService
    def initialize(user, integration_id)
      @user = user
      @integration_id = integration_id
    end

    def call
      pocket_integration.with_log(:pull_items) do
        pocket_client.items.each do |item|
          create_media_item_from_pocket_item! item
        end
      end
    end

    private

    attr_reader :user,
                :integration_id

    def pocket_client
      @pocket_client ||= Pocket::Client.new(pocket_integration)
    end

    def pocket_integration
      @pocket_integration ||= user.integrations.find(integration_id)
    end

    def create_media_item_from_pocket_item!(pocket_item)
      attrs = media_item_attrs(pocket_item).merge(queue: user.inbox_queue)
      user.media_items.create! attrs
    end

    def media_item_attrs(pocket_item)
      {
        title: pocket_item[:given_title] || pocket_item[:resolved_title],
        url: pocket_item[:given_url],
        estimated_consumption_time: pocket_item[:time_to_read],
        service_id: pocket_item[:item_id],
        service_type: 'Pocket',
      }
    end
  end
end
