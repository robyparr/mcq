require 'rails_helper'

RSpec.describe "media queue CRUD", type: :system do
  include Support::Helpers::CapybaraHelper

  let!(:current_user) { create :user }

  describe 'listing queues' do
    let!(:users_queue)         { create :queue, name: 'queue 1', user: current_user }
    let!(:another_users_queue) { create :queue, name: 'queue 2' }

    it 'shows queues for the current user' do
      visit root_path(as: current_user)

      expect(page).to have_css 'a.sub-link', text: users_queue.name
      expect(page).not_to have_css 'a.sub-link', text: another_users_queue.name
    end
  end

  describe 'clicking a queue' do
    let!(:queue)                { create :queue, name: 'queue 1', user: current_user }
    let!(:non_queue_media_item) { create :media_item, title: 'Non-Queue Media Item' }

    let!(:queue_media_item) do
      create :media_item, queue: queue,
                          title: 'Queue Media Item',
                          consumption_difficulty: 'easy'
    end

    it 'shows media items filtered by queue' do
      visit root_path(as: current_user)

      click_link queue.name
      expect(page).to have_current_path media_items_path(queue: queue)
      expect(page).to have_css 'h2.page-header', text: queue.name
      expect(page).to have_text queue_media_item.title
      expect(page).not_to have_text non_queue_media_item.title
    end
  end

  describe 'adding a queue' do
    it 'Adds the queue' do
      visit root_path(as: current_user)

      find_by_testid('new-queue-btn').click
      expect(page).to have_css 'h2.page-header', text: 'New Queue'

      fill_in 'Name', with: 'A new queue'
      click_button 'Create Media queue'

      wait_until { find('.toast.info').present? }

      created_queue = current_user.queues.last
      path_with_query = URI(page.current_url).request_uri

      expect(path_with_query).to eq media_items_path(queue: created_queue)
      expect(page).to have_css '.toast.info', text: 'Queue was successfully created'
      expect(page).to have_css 'h2.page-header', text: 'A new queue'
    end
  end

  describe 'Editing a queue' do
    let!(:queue) { create :queue, user: current_user }

    it 'Edits the queue' do
      visit root_path(as: current_user)
      click_link queue.name

      find_by_testid('page-overflow-btn').click
      click_link 'Edit Queue'

      expect(page).to have_css 'h2.page-header', text: 'Edit Queue'
      fill_in 'Name', with: 'Updated Queue'
      click_button 'Update Media queue'

      expect(page).to have_current_path media_items_path(queue: queue)
      expect(page).to have_css '.toast.info', text: 'Queue was successfully updated'
      expect(page).to have_css 'h2.page-header', text: 'Updated Queue'
    end
  end

  describe 'Deleting a queue' do
    let!(:queue) { create :queue, user: current_user }

    it 'Deletes the queue' do
      visit root_path(as: current_user)
      click_link queue.name

      find_by_testid('page-overflow-btn').click
      accept_confirm do
        click_link 'Delete Queue'
      end

      expect(page).to have_current_path media_items_path
      expect(page).to have_css '.toast.info', text: 'Queue was successfully destroyed.'
      expect(page).not_to have_css '.navigation-item', text: queue.name
    end
  end
end
