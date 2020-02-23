import { Controller } from 'stimulus'

export default class extends Controller {
  renderTemplate({ el, name, data = {} }) {
    if (!this.hasTemplates())
      return

    const template = _(this.controllerClass().templates[name])
                       .chain()
                       .trim()
                       .template()
                       .value()

    el.innerHTML = template(data)
  }

  cleanTemplate(template) {
    return _(template).trim()
  }

  hasTemplates() {
    return _.keys(this.controllerClass().templates).length > 0
  }

  controllerClass() {
    return this.constructor
  }
}
