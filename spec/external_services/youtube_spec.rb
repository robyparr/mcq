require 'rails_helper'

RSpec.describe YouTube do
  describe '.extract_video_id_from_youtube_url' do
    [
      'https://youtube.com/watch?v=video_id',
      'https://www.youtube.com/watch?v=video_id',
      'https://youtu.be/video_id',
      'https://www.youtu.be/video_id',
    ].each do |url|
      it "extracts the video ID from #{url}" do
        expect(described_class.extract_video_id_from_youtube_url(url)).to eq('video_id')
      end
    end
  end
end
