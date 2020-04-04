import ApplicationController from './application_controller'

export default class extends ApplicationController {
  static targets = [
    'button',
    'hidden',
  ]

  static templates = {
    hiddenField: `
      <input type="hidden"
             name="<%- name %>"
             data-target="toggle-buttons.hidden"
             value="<%- value %>" />
    `
  }

  connect() {
    this.injectHiddenField()
    this.addEventListeners()
  }

  injectHiddenField() {
    const currentlyToggledButton =
      this.buttonTargets.find(button => button.classList.contains('toggled'))

    const hiddenFieldName = this.data.get('field-name')
    this.renderTemplate({
      el: this.element,
      name: 'hiddenField',
      insertMode: 'append',
      data: {
        name: hiddenFieldName,
        value: currentlyToggledButton ? currentlyToggledButton.dataset.value : null
      }
    })
  }

  addEventListeners() {
    this.buttonTargets.forEach(button => {
      button.addEventListener('click', () => this.toggleButton(button))
    })
  }

  toggleButton(button) {
    this.buttonTargets.forEach(button => button.classList.remove('toggled'))
    button.classList.add('toggled')
    this.hiddenTarget.value = button.dataset.value
  }
}
