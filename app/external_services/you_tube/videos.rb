module YouTube
  module Videos
    def video(id)
      params = default_params.merge(
        id:   id,
        part: 'snippet,contentDetails',
      ).stringify_keys

      response = get('/videos', params)

      if response[:items].present?
        YouTube::Mapper.map_video response[:items].first
      else
        {}
      end
    end
  end
end
