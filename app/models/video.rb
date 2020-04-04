class Video < MediaItem
  def estimate_consumption_time!
    youtube_video_id = YouTube.extract_video_id_from_youtube_url(url)
    return unless youtube_video_id.present?

    youtube_client = YouTube::Client.new
    youtube_video = youtube_client.video(youtube_video_id)

    self.estimated_consumption_time = youtube_video[:duration]

    # TODO: Refactor with `estimate_consumption_time!`
    self.service_type = 'YouTube'
    self.service_id = youtube_video_id
  end
end