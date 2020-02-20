import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = [
    'editor',
    'display'
  ]
  connect() {
    this.state = 'display'
    this.toggleDisplayMode()
  }

  swapState() {
    this.state = this.state === 'display' ? 'edit' : 'display'

    if (this.state === 'display') {
      this.toggleDisplayMode()
    } else {
      this.toggleEditMode()
    }
  }

  toggleDisplayMode() {
    this.editorTargets.forEach(target => target.style.display = 'none')
    this.displayTargets.forEach(target => target.style.display = 'initial')
  }

  toggleEditMode() {
    this.editorTargets.forEach(target => target.style.display = 'initial')
    this.displayTargets.forEach(target => target.style.display = 'none')
  }
}
