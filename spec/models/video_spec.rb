require 'rails_helper'

RSpec.describe Video, type: :model do
  describe '#estimate_consumption_time!' do
    context 'without a url' do
      let(:video) { build_stubbed(:video, url: nil) }

      it 'should not update the estimated consumption time' do
        expect { video.estimate_consumption_time! }
          .not_to change(video, :estimated_consumption_time)
      end
    end

    context 'with a url' do
      let(:youtube_video_id) { 'some-random-id' }
      let(:video) { build_stubbed(:video, url: "https://youtu.be/#{youtube_video_id}") }

      it 'should calculate estimated reading time' do
        expect_any_instance_of(YouTube::Client)
          .to receive(:video)
          .with(youtube_video_id)
          .and_return(duration: 90)

        expect { video.estimate_consumption_time! }
          .to change(video, :estimated_consumption_time).from(nil).to(2)
      end
    end
  end
end
