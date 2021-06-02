import { Controller } from 'stimulus'

export default class extends Controller {
  click() {
    history.pushState(
      null,
      null,
      this.getLinkUrl(),
    )
  }

  getLinkUrl() {
    return this.element.getAttribute('href')
  }
}
