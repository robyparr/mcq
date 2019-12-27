RSpec.shared_examples 'loggable' do
  describe 'associations' do
    it { is_expected.to have_many(:activity_logs) }
  end

  describe '#with_log' do
    it 'creates a log if the block returns true' do
      link = build(:link)

      expect do
        link.with_log(:create) { link.save }
      end.to change(Link, :count).by(1)
         .and change(ActivityLog, :count).by(1)

      expect(link).to be_persisted
      expect(link.activity_logs.count).to eq(1)
    end

    it 'rolls back any changes and does not log if the block returns false' do
      link = build(:link)

      expect do
        link.with_log(:create) do
          link.save
          false
        end
      end.to change(Link, :count).by(0)
         .and change(ActivityLog, :count).by(0)

      expect(link).not_to be_persisted
      expect(link.activity_logs.count).to eq(0)
    end
  end
end
