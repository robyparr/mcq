import ApplicationController from './application_controller'

export default class extends ApplicationController {
  static targets = [
    'navigation'
  ]

  toggleNavigation() {
    this.navigationTarget.classList.toggle('hidden')
  }
}
