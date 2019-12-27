require 'rails_helper'

RSpec.describe ActivityLog, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:record) }
  end
end
