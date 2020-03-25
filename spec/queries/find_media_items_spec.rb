require 'rails_helper'

RSpec.describe FindMediaItems do
  describe '.call' do
    context 'using default relation with no params' do
      let!(:media_items) { create_list :media_item, 2 }

      it 'returns all media items' do
        results = described_class.call
        expect(results.pluck(:id)).to match_array(media_items.pluck(:id))
      end
    end

    context 'with scope' do
      let!(:media_items) { create_list :media_item, 2 }
      let(:user) { media_items.first.user }

      it 'returns media items within the scope' do
        results = described_class.call(user.media_items)
        expect(results.pluck(:id)).to match_array([media_items.first.id])
      end
    end

    it 'filters by difficulty' do
      easy_media_item = create :media_item, consumption_difficulty: 'easy'
      hard_media_item = create :media_item, consumption_difficulty: 'hard'

      results = described_class.call(nil, { difficulty: 'easy' })
      expect(results.pluck(:id)).to match_array([easy_media_item.id])
    end

    it 'filters by priority' do
      low = create :priority, title: 'low'
      high = create :priority, title: 'high'

      low_media_item = create :media_item, priority: low
      high_media_item = create :media_item, priority: high

      results = described_class.call(nil, { priority: low.id })
      expect(results.pluck(:id)).to match_array([low_media_item.id])
    end
  end
end
