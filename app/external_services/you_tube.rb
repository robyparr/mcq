module YouTube
  URL_REGEXES = [
    /\Ahttps:\/\/(?:www\.)?(?:m\.)?youtube\..+\/watch\?v=([\w_-]+)(?:\&.+)?\z/,
    /\Ahttps:\/\/(?:www\.)?(?:m\.)?youtu\.be\/([\w_-]+)(?:\?.+)?\z/,
  ]

  class << self
    def extract_video_id_from_url(url)
      URL_REGEXES.each do |regex|
        match = regex.match(url)
        return match.captures.first if match
      end

      nil
    end
  end
end
