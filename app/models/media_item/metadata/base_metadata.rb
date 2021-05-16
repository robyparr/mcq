class MediaItem::Metadata::BaseMetadata
  def initialize(service_id, media_item:)
    @service_id = service_id
    @media_item = media_item
  end

  private

  attr_reader :service_id,
              :media_item
end
