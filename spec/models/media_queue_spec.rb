require 'rails_helper'

RSpec.describe MediaQueue, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:color) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }

    it { is_expected.to have_many(:media_items).dependent(:nullify) }
    it { is_expected.to have_many(:active_media_items).dependent(:nullify) }
  end

  describe '#update_active_media_items_count!' do
    let(:user) { create :user }
    subject { create :queue, user: user }
    let!(:media_item) { create :media_item, user: user, queue: subject }
    let!(:complete_media_item) { create :media_item, user: user, queue: subject, complete: true }

    let!(:different_queue_media_item) { create :media_item, user: user }

    it 'updates #active_media_items_count to the size of the active_media_items relation' do
      expect(subject.reload.active_media_items.count).to eq 1
      subject.update_column :active_media_items_count, 0

      expect { subject.update_active_media_items_count! }
        .to change(subject.reload, :active_media_items_count).from(0).to(1)
    end

    it 'raise an error if it can not save the count' do
      expect(subject.reload.active_media_items.count).to eq 1
      subject.update_column :active_media_items_count, 0

      subject.name = nil
      expect { subject.update_active_media_items_count! }
        .to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
