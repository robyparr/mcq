RSpec.shared_examples 'loggable' do
  describe 'associations' do
    it { is_expected.to have_many(:activity_logs) }
  end

  describe '#with_log' do
    before do
      allow_any_instance_of(MediaItem).to receive(:log_creation!)
    end

    it 'creates a log if the block returns true' do
      media_item = create(:media_item)

      expect do
        media_item.with_log(:update) { media_item.update(title: 'new title') }
      end.to change(media_item, :title).to('new title')
         .and change(ActivityLog, :count).by(1)

      expect(media_item).to be_persisted
      expect(media_item.activity_logs.count).to eq(1)
    end

    it 'rolls back any changes and does not log if the block returns false' do
      media_item = build(:media_item)

      expect do
        media_item.with_log(:create) do
          media_item.save
          false
        end
      end.to change(MediaItem, :count).by(0)
         .and change(ActivityLog, :count).by(0)

      expect(media_item).not_to be_persisted
      expect(media_item.activity_logs.count).to eq(0)
    end
  end
end
