require 'rails_helper'

RSpec.describe Link, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:url) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'behaviours' do
    it_behaves_like 'loggable'
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

  describe '#mark_complete' do
    context 'when not complete' do
      it 'marks it as complete and returns true' do
        link = build(:link, title: 'title', url: 'https://example.com', complete: false)

        result = nil
        expect { result = link.mark_complete }
          .to change(link, :complete?).from(false).to(true)
          .and change(link.activity_logs, :count).from(0).to(1)

        expect(result).to eq(true)
        expect(link).to be_complete
      end
    end

    context 'when already complete' do
      it 'marks it as complete and returns true' do
        link = build(:link, title: 'title', url: 'https://example.com', complete: true)

        result = nil
        expect { result = link.mark_complete }.to change(link.activity_logs, :count).by(0)

        expect(result).to eq(false)
      end
    end
  end
end
