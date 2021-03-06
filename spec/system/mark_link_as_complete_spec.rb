require 'rails_helper'

RSpec.describe 'mark media as complete', type: :system do
  let!(:current_user) { create :user }

  describe 'marking a media as complete' do
    let!(:queue) { create :queue, name: 'My queue', user: current_user }
    let!(:media_item) do
      create :media_item,
             user: current_user,
             queue: queue,
             title: 'Media 1',
             complete: false
    end

    it do
      visit media_items_path(queue, as: current_user)
      expect(page).to have_content(media_item.title)

      click_on media_item.title
      click_button 'Mark Completed'
      expect(page).to have_content('Marked media as completed.')

      # Confirm media item is not visible from media list page by default
      visit media_items_path(as: current_user)
      expect(page).not_to have_content(media_item.title)

      # Confirm media item is visible from media list page when searching for complete items
      visit media_items_path(as: current_user, state: :complete)
      expect(page).to have_content(media_item.title)
    end
  end
end
