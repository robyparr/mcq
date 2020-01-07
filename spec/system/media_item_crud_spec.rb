require 'rails_helper'

RSpec.describe "media item CRUD", type: :system do
  let!(:current_user) { create :user }

  describe 'listing media items' do
    let!(:users_media_items)         { create :media_item, title: 'media 1', user: current_user }
    let!(:another_users_media_items) { create :media_item, title: 'media 2' }

    it 'shows media items for the current user' do
      visit media_items_path(as: current_user)

      expect(page).to have_css 'h1', text: 'Media'
      expect(page).to have_css 'td', text: users_media_items.title
      expect(page).not_to have_css 'td', text: another_users_media_items.title
    end
  end

  describe 'showing a media item' do
    let!(:media_item) { create :media_item, title: 'media 1', user: current_user }

    it 'shows the media item' do
      visit media_item_path(media_item, as: current_user)
      expect(page).to have_css 'h2.page-header', text: media_item.title
    end
  end

  describe 'adding a media item' do
    let!(:queue) { create :queue, user: current_user }

    it 'Adds the media item' do
      visit new_media_item_path(as: current_user)

      expect(page).to have_css 'h1', text: 'New Media'

      fill_in 'https://...', with: 'https://example.com'
      fill_in 'Title', with: 'New Media'

      click_button 'Create Media'

      expect(page).to have_current_path media_item_path(current_user.media_items.last)
      expect(page).to have_css '.alert.notice', text: 'Created new media'
      expect(page).to have_css 'h2.page-header', text: 'New Media'
    end
  end

  describe 'Editing a media item' do
    let!(:media_item) { create :media_item, user: current_user }

    it 'Edits the media item' do
      visit media_items_path(as: current_user)
      click_link 'Edit'

      expect(page).to have_css 'h1', text: 'Edit Media'

      fill_in 'https://...', with: 'https://example2.com'
      fill_in 'Title', with: 'Edited Media'

      click_button 'Update Media'

      expect(page).to have_current_path media_item_path(media_item)
      expect(page).to have_css '.alert.notice', text: 'Updated media'
      expect(page).to have_css 'h2.page-header', text: 'Edited Media'
    end
  end

  describe 'Deleting a media item' do
    let!(:media_item) { create :media_item, user: current_user }

    it 'Deletes the media item' do
      visit media_items_path(as: current_user)

      accept_confirm do
        click_link 'Delete'
      end

      expect(page).to have_current_path media_items_path
      expect(page).to have_css '.alert.notice', text: "Media '#{media_item.title}' deleted."
      expect(page).not_to have_css 'td', text: media_item.title
    end
  end

  describe 'Adding a media item from any page' do
    it 'links to the add media item form from the queues index page' do
      visit queues_path(as: current_user)

      expect(page).to have_css '.button', text: 'New Media'
      click_link 'New Media'

      expect(page).to have_current_path new_media_item_path
    end

    it 'links to the add media item form from the media item show page' do
      media_item = create(:media_item, user: current_user)
      visit media_item_path(media_item, as: current_user)

      expect(page).to have_css '.button', text: 'New Media'
      click_link 'New Media'

      expect(page).to have_current_path new_media_item_path
    end
  end
end
