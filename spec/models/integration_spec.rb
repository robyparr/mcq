require 'rails_helper'

RSpec.describe Integration, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe '.completed' do
    let!(:completed_integration) { create :integration, auth_token: '123' }
    let!(:incomplete_integration) { create :integration, auth_token: nil }

    it 'returns records that have a value for auth_token' do
      expect(described_class.completed.pluck(:id)).to eq([completed_integration.id])
    end
  end
end
