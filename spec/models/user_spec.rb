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

    describe '#inbox_queue' do
      let(:user) { create :user }

      context 'user does not have an inbox queue' do
        it 'creates an inbox queue' do
          expect do
            expect(user.inbox_queue).to have_attributes(
              name: 'Inbox',
              color: '#eee',
            )
          end.to change(user.queues, :count).from(0).to(1)
        end
      end

      context 'user already has an inbox queue' do
        let!(:inbox_queue) { create :queue, user: user, name: 'Inbox' }

        it 'retrieves the queue' do
          expect do
            expect(user.inbox_queue).to have_attributes(
              name: 'Inbox'
            )
          end.not_to change(user.queues, :count)
        end
      end
    end
  end
end
