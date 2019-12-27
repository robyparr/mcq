require 'rails_helper'

RSpec.describe "mark link as complete", type: :system do
  let!(:current_user) { create :user }

  describe 'marking a link as complete' do
    let!(:queue) { create :queue, name: 'My queue', user: current_user }
    let!(:link)  { create :link, queue: queue, title: 'link 1', user: current_user, complete: false }

    it do
      # Confirm link is visible within queue
      visit queue_path(queue, as: current_user)
      expect(page).to have_content(link.title)
      
      # Navigate to links#show
      click_on 'View'
      expect(page).to have_selector("input[type=submit][value='Mark Completed']")
      
      # Mark as completed
      click_button 'Mark Completed'
      expect(page).to have_content('Marked link as completed.')
      
      # Confirm link isn't visible within queue
      visit queue_path(queue, as: current_user)
      expect(page).not_to have_content(link.title)

      # Confirm link is visible from links page
      visit links_path(as: current_user)
      expect(page).to have_content(link.title)
    end
  end
end
