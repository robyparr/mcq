require 'rails_helper'

RSpec.describe PullPocketItemsJob, type: :job do
  describe '#perform' do
    let!(:user_one) { create :user }
    let!(:pocket_integration) { create :integration, :pocket, user: user_one }

    let!(:user_two) { create :user }

    it 'calls Pocket::PullItems for each user with a pocket integration' do
      expect(Pocket::PullItems)
        .to receive(:call)
        .with(user_one, pocket_integration.id)
        .once

      expect(Pocket::PullItems)
        .not_to receive(:call)
        .with(user_two)

      described_class.perform_now
    end
  end
end
