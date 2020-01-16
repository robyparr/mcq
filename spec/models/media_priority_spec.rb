require 'rails_helper'

RSpec.describe MediaPriority, type: :model do
  describe 'validations' do
    subject { create :priority }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_uniqueness_of(:title).scoped_to(:user_id) }

    it { is_expected.to validate_presence_of(:priority) }
    it { is_expected.to validate_uniqueness_of(:priority).scoped_to(:user_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end
end
