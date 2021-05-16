class MediaItem::Metadata
  def initialize(service_id:, service_name:, media_item:)
    @service_id   = service_id
    @service_name = service_name
    @media_item   = media_item
  end

  class << self
    def from_url(url, media_item:)
      case
      when service_id = ::YouTube.extract_video_id_from_url(url)
        new service_id: service_id, service_name: 'YouTube', media_item: media_item
      else
        new service_id: nil, service_name: nil, media_item: media_item
      end
    end
  end

  def to_media_item_attributes
    {
      service_type:               service_name,
      service_id:                 service_id,
      estimated_consumption_time: consumption_time,
    }
  end

  private

  attr_reader :service_name,
              :service_id,
              :media_item

  delegate :title,
           :consumption_time,
           to: :service_metadata_client

  SERVICE_METADATA_CLIENTS = {
    'YouTube' => ::MediaItem::Metadata::YouTube,
    'Article' => ::MediaItem::Metadata::WebArticle,
  }.freeze

  def service_metadata_client
    return @service_metadata_client if @service_metadata_client.present?

    client = SERVICE_METADATA_CLIENTS.fetch(service_name, MediaItem::Metadata::WebArticle)
    @service_metadata_client = client.new(service_id, media_item: media_item)
  end
end
