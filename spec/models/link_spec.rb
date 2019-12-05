require 'rails_helper'

RSpec.describe Link, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:url) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe '#title_or_url' do
    let(:link) { build :link, title: 'title', url: 'https://example.com' }

    context 'when the title attribute is set' do
      it 'returns the title' do
        expect(link.title_or_url).to eq 'title'
      end
    end

    context 'when the title attribute is set' do
      it 'returns the url' do
        link.title = nil
        expect(link.title_or_url).to eq 'https://example.com'
      end
    end
  end
end
