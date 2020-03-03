require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:media_items).dependent(:destroy) }
    it { is_expected.to have_many(:queues).class_name('MediaQueue').dependent(:destroy) }
    it { is_expected.to have_many(:media_priorities).dependent(:destroy) }
    it { is_expected.to have_many(:notes).through(:media_items) }
    it { is_expected.to have_many(:integrations).dependent(:destroy) }

    describe 'pocket_integration' do
      let!(:user) { create :user }
      let!(:pocket_integration) { create :integration, service: 'Pocket', user: user }
      let!(:other_integration) { create :integration, service: 'SomethingElse', user: user }

      it 'returns a single pocket-type integration' do
        expect(user.pocket_integration.id).to eq(pocket_integration.id)
      end
    end
  end
end
