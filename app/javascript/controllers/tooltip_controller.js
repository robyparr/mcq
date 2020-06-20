import ApplicationController from './application_controller'
import _delay from 'lodash/delay'

export default class extends ApplicationController {
  static targets = [
    'wrapper',
    'template',
  ]

  static templates = {
    wrapper: `
      <div class="relative" data-target="tooltip.wrapper"></div>
    `,

    tooltip: `
      <div class="absolute bg-white border rounded shadow-lg transform translate-y-1 w-auto z-10">
        <%= template %>
      </div>
    `
  }

  connect() {
    this.injectWrapper()
  }

  disconnect() {
    this.hide()
  }

  injectWrapper() {
    this.renderTemplate({
      el: this.element,
      name: 'wrapper',
      insertMode: 'insert',
    })
  }

  show() {
    this.renderTemplate({
      el: this.wrapperTarget,
      name: 'tooltip',
      insertMode: 'replace',
      data: { template: this.templateTarget.innerHTML }
    })

    _delay(() => document.addEventListener('click', this.hide))
  }

  hide = () => {
    this.wrapperTarget.innerHTML = ''
    document.removeEventListener('click', this.hide)
  }
}
