class MediaItem::Metadata::YouTube < MediaItem::Metadata::BaseMetadata
  def title
    youtube_video[:title]
  end

  def consumption_time
    youtube_video[:duration]
  end

  private

  def youtube_video
    return @youtube_video if @youtube_video.present?

    youtube_client = YouTube::Client.new
    @youtube_video = youtube_client.video(service_id)
  end
end
