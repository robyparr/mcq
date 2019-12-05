require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:links).dependent(:destroy) }
    it { is_expected.to have_many(:queues).class_name('MediaQueue').dependent(:destroy) }
  end
end
