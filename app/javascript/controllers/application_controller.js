import { Controller } from 'stimulus'
import _get from 'lodash/get'
import _trim from 'lodash/trim'
import _template from 'lodash/template'
import _keys from 'lodash/keys'
import _has from 'lodash/has'

export default class extends Controller {
  renderTemplate({ el, name, insertMode = 'replace', data = {} }) {
    if (!this.hasTemplates())
      return

    const template = _trim(_get(this.controllerClass().templates, name))
    const compiledTemplate = _template(template)
    const renderedTemplate = compiledTemplate(data)
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
    return _keys(this.controllerClass().templates).length > 0
  }

  hasTemplate(templateName) {
    return _has(this.controllerClass().templates, templateName)
  }

  controllerClass() {
    return this.constructor
  }
}
