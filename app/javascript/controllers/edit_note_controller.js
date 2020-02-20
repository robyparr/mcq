import { Controller } from 'stimulus'
import Utils from '../src/utils';

export default class extends Controller {
  static targets = [
    'title',
    'titleInput',
    'content',
    'contentInput',
  ]

  save() {
    Utils.fetch(`/notes/${this.getNoteID()}`, {
      method: 'PUT',
      body: {
        media_note: {
          title: this.titleInputTarget.value,
          content: this.contentInputTarget.value,
        }
      }
    })
      .then(json => {
        this.titleTarget.innerText = json.title || ''
        this.contentTarget.innerHTML = json.content || ''
      })
      .catch(response => console.log('error: ', response))
  }

  getNoteID() {
    return this.element.dataset.noteId;
  }
}
