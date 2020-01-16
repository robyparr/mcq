require 'rails_helper'

RSpec.describe MediaNote, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:media_item) }
  end
end
