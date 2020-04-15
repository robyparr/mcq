require 'rails_helper'

RSpec.describe Article, type: :model do
  describe '#estimate_consumption_time!' do
    context 'without a url' do
      let(:article) { build_stubbed(:article, url: nil) }

      it 'should not update the estimated consumption time' do
        expect { article.estimate_consumption_time! }
          .not_to change(article, :estimated_consumption_time)
      end
    end

    context 'with a url' do
      let(:url_content) { ('word ' * 400).chomp }
      let(:article) { build_stubbed(:article, url: 'https://example.com') }

      it 'should calculate estimated reading time' do
        allow(URI).to receive_message_chain(:open, :read).and_return(url_content)

        expected_reading_time = 2 # 400 words / (200 words per minute)
        expect { article.estimate_consumption_time! }
          .to change(article, :estimated_consumption_time).from(nil).to(expected_reading_time)
      end
    end
  end
end
