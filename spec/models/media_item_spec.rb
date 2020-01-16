require 'rails_helper'

RSpec.describe MediaItem, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:url) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:queue).class_name('MediaQueue').with_foreign_key(:media_queue_id) }
    it do
      is_expected.to belong_to(:priority)
        .class_name('MediaPriority')
        .with_foreign_key(:media_priority_id)
        .optional
    end

    it { is_expected.to have_many(:notes).class_name('MediaNote').dependent(:destroy) }
  end

  describe 'behaviours' do
    it_behaves_like 'loggable'
  end

  describe 'callbacks' do
    it { is_expected.to callback(:log_creation!).after(:create) }
  end

  describe '#title_or_url' do
    let(:media_item) { build :media_item, title: 'title', url: 'https://example.com' }

    context 'when the title attribute is set' do
      it 'returns the title' do
        expect(media_item.title_or_url).to eq 'title'
      end
    end

    context 'when the title attribute is set' do
      it 'returns the url' do
        media_item.title = nil
        expect(media_item.title_or_url).to eq 'https://example.com'
      end
    end
  end

  describe '#mark_complete' do
    before do
      allow_any_instance_of(MediaItem).to receive(:log_creation!)
    end

    context 'when not complete' do
      it 'marks it as complete and returns true' do
        media_item = build(:media_item, title: 'title', url: 'https://example.com', complete: false)

        result = nil
        expect { result = media_item.mark_complete }
          .to change(media_item, :complete?).from(false).to(true)
          .and change(media_item.activity_logs, :count).from(0).to(1)

        expect(result).to eq(true)
        expect(media_item).to be_complete
      end
    end

    context 'when already complete' do
      it 'marks it as complete and returns true' do
        media_item = build(:media_item, title: 'title', url: 'https://example.com', complete: true)

        result = nil
        expect { result = media_item.mark_complete }.to change(media_item.activity_logs, :count).by(0)

        expect(result).to eq(false)
      end
    end
  end
end
