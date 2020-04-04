module YouTube
  YOUTUBE_VIDEO_ID_URL_REGEX_1 = /\Ahttps:\/\/(?:www\.)?youtube\..+\/watch\?v=(.+)/
  YOUTUBE_VIDEO_ID_URL_REGEX_2 = /\Ahttps:\/\/(?:www\.)?youtu\.be\/(.+)/

  def self.extract_video_id_from_youtube_url(url)
    match = YOUTUBE_VIDEO_ID_URL_REGEX_1.match(url)
    match ||= YOUTUBE_VIDEO_ID_URL_REGEX_2.match(url)

    match.captures.first if match.present?
  end
end
