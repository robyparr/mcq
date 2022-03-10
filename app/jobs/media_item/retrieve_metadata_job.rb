class MediaItem::RetrieveMetadataJob < ApplicationJob
  queue_as :default

  def perform(media_id)
    media_item = MediaItem.find(media_id)
    media_item.assign_metadata_from_source
    media_item.assign_estimated_consumption_difficulty
    media_item.save!
  end
end
