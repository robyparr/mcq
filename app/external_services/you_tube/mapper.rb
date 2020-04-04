module YouTube
  module Mapper
    class << self
      def map_video(video)
        {
          id: video[:id],
          title: video.dig(:snippet, :title),
          duration: iso_duration_to_seconds(video.dig(:contentDetails, :duration)),
        }
      end

      private

      def iso_duration_to_seconds(duration)
        ActiveSupport::Duration.parse(duration).seconds
      end
    end
  end
end
