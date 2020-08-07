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
    it_behaves_like 'snoozeable', factory: :media_item
  end

  describe 'callbacks' do
    it { is_expected.to callback(:log_creation!).after(:create) }
  end

  describe '::MEDIA_TYPES' do
    it do
      expect(described_class::MEDIA_TYPES).to match_array(%i[
        Article
        Video
      ])
    end
  end

  describe '.completed' do
    let!(:completed_media_item) { create :media_item, complete: true }
    let!(:not_completed_media_item) { create :media_item, complete: false }

    it 'only returns completed media items' do
      expect(described_class.completed.pluck(:id)).to match_array([
        completed_media_item.id
      ])
    end
  end

  describe '.not_completed' do
    let!(:completed_media_item) { create :media_item, complete: true }
    let!(:not_completed_media_item) { create :media_item, complete: false }

    it 'only returns not completed media items' do
      expect(described_class.not_completed.pluck(:id)).to match_array([
        not_completed_media_item.id
      ])
    end
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

  describe '#estimated_consumption_time' do
    let(:time_in_seconds) { 120 }
    let(:time_in_minutes) { 2 }

    let(:media_item) { build_stubbed(:media_item, estimated_consumption_time: time_in_seconds) }
    it 'returns time in minutes' do
      expect(media_item.estimated_consumption_time).to eq time_in_minutes
    end
  end

  describe '#estimate_consumption_difficulty!' do
    context 'consumption_difficulty is already defined' do
      it 'should not change the consumption difficulty' do
        media_item = build_stubbed(
          :media_item,
          estimated_consumption_time: 2,
          consumption_difficulty: 'hard'
        )

        expect { media_item.estimate_consumption_difficulty! }
          .not_to change(media_item, :consumption_difficulty)
      end
    end

    context 'without estimated_consumption_time' do
      it 'should not change the consumption difficulty' do
        media_item = build_stubbed(:media_item, estimated_consumption_time: nil)

        expect { media_item.estimate_consumption_difficulty! }
          .not_to change(media_item, :consumption_difficulty)
      end
    end

    context 'with estimated_consumption_time' do
      let(:time_to_difficulty_mapping) do
        {
          5.minutes  => 'easy',
          20.minutes => 'medium',
          30.minutes => 'hard',
        }
      end

      {
        5.minutes  => 'easy',
        20.minutes => 'medium',
        30.minutes => 'hard',
      }.each do |time, difficulty|
        it "should change the consumption difficulty to #{difficulty}" do
          media_item = build_stubbed(:media_item, estimated_consumption_time: time.seconds)

          expect { media_item.estimate_consumption_difficulty! }
            .to change(media_item, :consumption_difficulty).from(nil).to(difficulty)
        end
      end
    end
  end

  describe '#[type]?' do
    described_class::MEDIA_TYPES.each do |type|
      it "##{type.downcase}? returns `true` if type is `#{type}` or `false` otherwise" do
        media_item = build_stubbed(:media_item, type: type)
        expect(media_item.send("#{type.downcase}?")).to eq(true)

        other_type = (described_class::MEDIA_TYPES - [type]).sample
        expect(media_item.send("#{other_type.downcase}?")).to eq(false)
      end
    end
  end

  describe 'creation' do
    let(:queue) { create :queue }

    it "calls its queue's update_active_media_items_count! method" do
      expect(queue).to receive(:update_active_media_items_count!).once
      create :media_item, queue: queue
    end
  end

  describe 'update' do
    let!(:queue) { create :queue }
    let!(:media_item) { create :media_item, queue: queue }

    it "calls its queue's update_active_media_items_count! method" do
      expect(queue).to receive(:update_active_media_items_count!).once
      media_item.update title: 'new title'
    end

    it "calls its queue's and old queue's update_active_media_items_count! method" do
      new_queue = create(:queue)
      expect(new_queue).to receive(:update_active_media_items_count!).once
      expect_any_instance_of(MediaQueue).to receive(:update_active_media_items_count!).once

      media_item.update queue: new_queue
    end
  end

  describe 'deletion' do
    let!(:queue) { create :queue }
    let!(:media_item) { create :media_item, queue: queue }

    it "calls its queue's update_active_media_items_count! method" do
      expect(queue).to receive(:update_active_media_items_count!).once
      media_item.destroy
    end
  end
end
