import { Controller } from 'stimulus'

export default class extends Controller {
  renderTemplate({ el, name, insertMode = 'replace', data = {} }) {
    if (!this.hasTemplates())
      return

    const template = _(this.controllerClass().templates)
                       .chain()
                       .get(name)
                       .trim()
                       .template()
                       .value()

    const renderedTemplate = template(data)
    if (insertMode === 'replace') {
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

  hasTemplate(templateName) {
    return _.has(this.controllerClass().templates, templateName)
  }

  controllerClass() {
    return this.constructor
  }
}
