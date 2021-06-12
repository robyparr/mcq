require 'rails_helper'

RSpec.describe "setup media priorities", type: :system do
  include Support::Helpers::CapybaraHelper

  let!(:current_user) { create :user }

  describe 'creating priorities' do
    let!(:priority) { create :priority, title: 'Top', priority: 1, user: current_user }

    it 'creates and lists priorities' do
      visit media_priorities_path(as: current_user)

      # Show existing priority
      expect(page).to have_css 'h2.page-header', text: 'Media Priorities'
      expect(page).to have_css 'td', text: priority.title
      expect(page).to have_css 'td', text: priority.priority

      # Add new priority
      expect do
        fill_in 'Title', with: 'Low Priority'
        fill_in 'Priority', with: 5
        click_button 'Create Media priority'

        wait_until { page.find('.toast.info').present? }
      end.to change(current_user.media_priorities, :count).from(1).to(2)

      # Show newly added priority
      expect(page).to have_current_path media_priorities_path
      expect(page).to have_css '.toast.info', text: 'Created new priority'
      expect(page).to have_css 'td', text: 'Low Priority'
      expect(page).to have_css 'td', text: '5'
    end
  end
end
