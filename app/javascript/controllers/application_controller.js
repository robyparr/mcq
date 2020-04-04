import { Controller } from 'stimulus'

export default class extends Controller {
  renderTemplate({ el, name, insertBy = 'replace', data = {} }) {
    if (!this.hasTemplates())
      return

    const template = _(this.controllerClass().templates[name])
                       .chain()
                       .trim()
                       .template()
                       .value()

    const renderedTemplate = template(data)
    if (insertBy === 'replace') {
      el.innerHTML = renderedTemplate
    } else {
      el.insertAdjacentHTML('beforeend', renderedTemplate)
    }
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
