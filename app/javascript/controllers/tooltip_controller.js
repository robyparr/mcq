import ApplicationController from './application_controller'
import _delay from 'lodash/delay'

export default class extends ApplicationController {
  static targets = [
    'wrapper',
    'template',
  ]

  static tooltipID = 1;

  static templates = {
    tooltip: `
      <div id="tooltip_<%- tooltipID %>"
           class="absolute top-0 bg-white border rounded shadow-lg w-auto z-10">
        <%= template %>
      </div>
    `
  }

  disconnect() {
    this.hide()
  }

  show() {
    this.element.classList.add('relative')
    this.renderedTooltip = this.renderTooltip()
    this.incrementTooltipID()
    _delay(() => document.addEventListener('click', this.hide))
  }

  renderTooltip() {
    this.renderTemplate({
      el: this.element,
      name: 'tooltip',
      insertMode: 'insert',
      data: {
        template: this.templateTarget.innerHTML,
        tooltipID: this.tooltipID()
      }
    })

    const tooltipEl = $find(`#tooltip_${this.tooltipID()}`)
    tooltipEl.style.marginTop = `${this.element.offsetHeight + 2}px`
    tooltipEl.classList.add(`${this.alignTooltip()}-0`)

    renderIcons()

    return tooltipEl
  }

  hide = () => {
    document.removeEventListener('click', this.hide)

    this.renderedTooltip.remove()
    this.renderedTooltip = null
  }

  tooltipID() {
    return this.controllerClass().tooltipID
  }

  incrementTooltipID() {
    this.controllerClass().tooltipID++
  }

  alignTooltip() {
    return this.data.get('align') || 'left'
  }
}
