require 'rails_helper'

RSpec.describe "media queue CRUD", type: :system do
  let!(:current_user) { create :user }

  describe 'listing queues' do
    let!(:users_queue)         { create :queue, name: 'queue 1', user: current_user }
    let!(:another_users_queue) { create :queue, name: 'queue 2' }

    it 'shows queues for the current user' do
      visit queues_path(as: current_user)

      expect(page).to have_css 'h2.page-header', text: 'Queues'
      expect(page).to have_css 'td', text: users_queue.name
      expect(page).not_to have_css 'td', text: another_users_queue.name
    end
  end

  describe 'showing a queue' do
    let!(:queue) { create :queue, name: 'queue 1', user: current_user }

    it 'shows queue' do
      visit queue_path(queue, as: current_user)
      expect(page).to have_css 'h2.page-header', text: queue.name
    end
  end

  describe 'adding a queue' do
    it 'Adds the queue' do
      visit new_queue_path(as: current_user)

      expect(page).to have_css 'h2.page-header', text: 'New Queue'

      fill_in 'Name', with: 'A new queue'

      click_button 'Create Media queue'

      expect(page).to have_current_path queue_path(current_user.queues.last)
      expect(page).to have_css '.alert.notice', text: 'Queue was successfully created'
      expect(page).to have_css 'h2.page-header', text: 'A new queue'
    end
  end

  describe 'Editing a queue' do
    let!(:queue) { create :queue, user: current_user }

    it 'Edits the queue' do
      visit queues_path(as: current_user)
      click_link 'Edit'

      expect(page).to have_css 'h2.page-header', text: 'Edit Queue'

      fill_in 'Name', with: 'Updated Queue'

      click_button 'Update Media queue'

      expect(page).to have_current_path queue_path(queue)
      expect(page).to have_css '.alert.notice', text: 'Queue was successfully updated'
      expect(page).to have_css 'h2.page-header', text: 'Updated Queue'
    end
  end

  describe 'Deleting a queue' do
    let!(:queue) { create :queue, user: current_user }

    it 'Deletes the queue' do
      visit queues_path(as: current_user)

      accept_confirm do
        click_link 'Delete'
      end

      expect(page).to have_current_path queues_path
      expect(page).to have_css '.alert.notice', text: 'Queue was successfully destroyed.'
      expect(page).not_to have_css 'td', text: queue.name
    end
  end
end
