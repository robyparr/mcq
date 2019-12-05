require 'rails_helper'

RSpec.describe "link CRUD", type: :system do
  attr_reader :current_user

  let!(:current_user) { create(:user) }

  describe 'listing links' do
    let!(:users_link)         { create :link, title: 'link 1', user: current_user }
    let!(:another_users_link) { create :link, title: 'link 2' }

    it 'shows links for the current user' do
      visit links_path(as: current_user)

      expect(page).to have_css 'h1', text: 'Links'
      expect(page).to have_css 'td', text: users_link.title
      expect(page).not_to have_css 'td', text: another_users_link.title
    end
  end

  describe 'showing a link' do
    let!(:users_link)         { create :link, title: 'link 1', user: current_user }
    let!(:another_users_link) { create :link, title: 'link 2' }

    it 'shows links for the current user' do
      visit link_path(users_link, as: current_user)
      expect(page).to have_css 'h1', text: users_link.title
    end
  end

  describe 'adding a link' do
    it 'Adds the link' do
      visit new_link_path(as: current_user)

      expect(page).to have_css 'h1', text: 'New Link'

      fill_in 'https://...', with: 'https://example.com'
      fill_in 'Title', with: 'New Link'

      click_button 'Create Link'

      expect(page).to have_current_path links_path
      expect(page).to have_css '.alert.notice', text: 'Created new link'
      expect(page).to have_css 'td', text: 'New Link'
    end
  end

  describe 'Editing a link' do
    let!(:link) { create :link, user: current_user }

    it 'Edits the link' do
      visit links_path(as: current_user)
      click_link 'Edit'

      expect(page).to have_css 'h1', text: 'Edit Link'

      fill_in 'https://...', with: 'https://example2.com'
      fill_in 'Title', with: 'Edited Link'

      click_button 'Update Link'

      expect(page).to have_current_path link_path(link)
      expect(page).to have_css '.alert.notice', text: 'Updated link'
      expect(page).to have_css 'h1', text: 'Edited Link'
    end
  end

  describe 'Deleting a link' do
    let!(:link) { create :link, user: current_user }

    it 'Deletes the link' do
      visit links_path(as: current_user)

      accept_confirm do
        click_link 'Delete'
      end

      expect(page).to have_current_path links_path
      expect(page).to have_css '.alert.notice', text: "Link '#{link.title}' deleted."
      expect(page).not_to have_css 'td', text: link.title
    end
  end
end
