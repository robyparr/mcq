class Video < MediaItem
  def retrieve_metadata_from_source!
    return unless youtube_video.present?

    assign_attributes(
      service_type: 'YouTube',
      service_id: youtube_video_id,
    )
    self.title = title.presence || youtube_video[:title]
  end

  def estimate_consumption_time!
    return unless youtube_video_id.present?

    self.estimated_consumption_time = youtube_video[:duration]
  end

  private

  def youtube_video
    return @youtube_video if @youtube_video.present?

    youtube_client = YouTube::Client.new
    @youtube_video = youtube_client.video(youtube_video_id)
  end

  def youtube_video_id
    @youtube_video_id ||= YouTube.extract_video_id_from_youtube_url(url)
  end
end
