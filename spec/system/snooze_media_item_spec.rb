require 'rails_helper'

RSpec.describe 'snooze media item', type: :system do
  include Support::Helpers::CapybaraHelper

  let!(:current_user) { create :user }

  describe 'snoozing a media item' do
    let!(:media_item) { create :media_item, user: current_user, title: 'Media 1' }

    it do
      visit media_items_path(media_item, as: current_user)
      click_on media_item.title

      expect(page).to have_current_path(media_item_path(media_item))
      click_button 'Snooze'
      find_by_testid('snooze-until-tomorrow').click
      expect(page).to have_content('Snoozed until')
      expect(page).to have_content(media_item.reload.snooze_until.to_date.to_s)

      visit media_items_path(as: current_user)
      expect(page).not_to have_content(media_item.title)

      visit media_items_path(state: :snoozed, as: current_user)
      expect(page).to have_content(media_item.title)
    end
  end

  describe 'unsnoozing a media item' do
    let!(:media_item) do
      create :media_item,
             user: current_user,
             title: 'Media 1',
             snooze_until: Time.zone.now + 1.day
    end

    it do
      visit media_items_path(as: current_user)
      expect(page).not_to have_content(media_item.title)

      visit media_items_path(state: :snoozed, as: current_user)
      click_on media_item.title

      expect(page).to have_current_path(media_item_path(media_item))
      find_by_testid('snooze').click
      sleep 1
      find_by_testid('snooze-unsnooze').click
      expect(page).to have_content('Media item was unsnoozed')
      expect(page).not_to have_content(media_item.snooze_until.to_date.to_s)
    end
  end
end
