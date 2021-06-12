require 'rails_helper'

RSpec.describe 'media notes CRUD' do
  include Support::Helpers::CapybaraHelper

  let!(:current_user) { create :user }
  let!(:media_item) { create :media_item, user: current_user }
  let(:note_css_id) { "#media_note_#{note.id}" }

  describe 'adding a note' do
    let(:note) { current_user.notes.last }

    it 'adds a note' do
      visit media_item_path(media_item, as: current_user)

      find('#note-title').set 'Example Note'
      find('[data-controller="rich-editor"] .ql-editor').set 'This is a note!'
      find('input[type="submit"][value="Save Media note"]').click

      wait_until { find('[data-note-id]').present? }

      expect(note).to have_attributes(
        title: 'Example Note',
        content: '<p>This is a note!</p>',
        media_item_id: media_item.id,
      )

      expect(page).to have_css "#{note_css_id} .card-title", text: 'Example Note'
      expect(page).to have_css "#{note_css_id} .card-content", text: 'This is a note!'
    end
  end

  describe 'editing and deleting a note' do
    let!(:note) do
      create :media_note,
             media_item: media_item,
             title: 'Example Note',
             content: 'Some content.'
    end

    it 'edits a note' do
      visit media_item_path(media_item, as: current_user)

      expect(page).to have_css "#{note_css_id} .card-title", text: note.title

      note_card = find(note_css_id)
      note_card.find('.bi-pencil').click

      note_card_title = note_card.find('.card-title input[name=title]')
      note_card_content = note_card.find('.ql-editor')

      expect(note_card_title.value).to eq(note.title)
      expect(note_card_content.text).to eq(note.content)
    end

    it 'deletes a note' do
      visit media_item_path(media_item, as: current_user)

      expect(page).to have_css "#{note_css_id} .card-title", text: note.title

      note_card = find(note_css_id)
      accept_confirm { note_card.find('.bi-trash').click }

      expect(page).not_to have_css "#{note_css_id} .card-title", text: note.title
    end
  end
end
