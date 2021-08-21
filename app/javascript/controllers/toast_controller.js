import { Controller } from 'stimulus'

export default class extends Controller {
  TOAST_TIMEOUT_MS = 5000
  REMOVE_TOAST_TIMEOUT_MS = 500

  connect() {
    this.showToast()
    this.setToastTimeout()
  }

  showToast() {
    setTimeout(() => this.element.classList.toggle('visible', true), 0)
  }

  setToastTimeout() {
    setTimeout(() => this.removeToast(), this.TOAST_TIMEOUT_MS)
  }

  removeToast() {
    if (this.element) {
      this.element.classList.toggle('visible', false)
      setTimeout(() => this.element.remove(), this.REMOVE_TOAST_TIMEOUT_MS)
    }
  }
}
