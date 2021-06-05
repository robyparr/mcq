import { Controller } from 'stimulus'
import { navigator } from '@hotwired/turbo'

export default class extends Controller {
  click() {
    const url = new URL(this.getLinkUrl())
    navigator.history.push(url)
  }

  getLinkUrl() {
    const linkHref = this.element.getAttribute('href');

    if (linkHref.startsWith('http')) {
      return linkHref
    } else {
      return window.location.origin + linkHref
    }
  }
}
