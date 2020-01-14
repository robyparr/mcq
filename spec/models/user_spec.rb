require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:media_items).dependent(:destroy) }
    it { is_expected.to have_many(:queues).class_name('MediaQueue').dependent(:destroy) }
    it { is_expected.to have_many(:media_priorities).dependent(:destroy) }
  end
end
