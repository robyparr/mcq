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

    it 'filters by type' do
      article = create :article
      video = create :video

      results = described_class.call(nil, type: 'Video')
      expect(results.pluck(:id)).to match_array([video.id])
    end

    it 'filters by state' do
      complete = create :media_item, complete: true
      not_complete = create :media_item, complete: false
      snoozed = create :media_item, snooze_until: Time.zone.now + 1.day

      results = described_class.call(nil, state: :complete)
      expect(results.pluck(:id)).to match_array([complete.id])

      results = described_class.call(nil, state: :not_complete)
      expect(results.pluck(:id)).to match_array([not_complete.id])

      results = described_class.call(nil, state: :snoozed)
      expect(results.pluck(:id)).to match_array([snoozed.id])
    end

    context 'search' do
      it 'searches by title and url of media items' do
        media_item = create :media_item, title: 'media item', url: 'https://example.com'
        create :media_item, title: 'item', url: 'https://robyparr.com'

        results = described_class.call(nil, { search: 'media' })
        expect(results.pluck(:id)).to match_array([media_item.id])

        results = described_class.call(nil, { search: 'example.com' })
        expect(results.pluck(:id)).to match_array([media_item.id])
      end

      it 'searches by title and content of notes' do
        media_item = create :media_item
        create :media_note, media_item: media_item, title: 'note', content: 'some contents'

        results = described_class.call(nil, { search: 'note' })
        expect(results.pluck(:id)).to match_array([media_item.id])

        results = described_class.call(nil, { search: 'contents' })
        expect(results.pluck(:id)).to match_array([media_item.id])
      end
    end
  end
end
