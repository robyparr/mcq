import ApplicationController from "./application_controller";

export default class extends ApplicationController {
  static targets = [
    'content',
    'loading',
    'selector',
  ]

  static values = {
    selectedClass: String,
  }

  connect() {
    this.showLoadingMinimumMs = 300

    this.markSelectorAsSelected(document.location.href)
  }

  displayLoading(event) {
    this.startedAt = new Date()
    this.loadingTarget.classList.remove('hidden')
    this.contentTarget.classList.add('hidden')

    this.markSelectorAsSelected(event.target.href)
  }

  displayContent() {
    setTimeout(() => {
      this.loadingTarget.classList.add('hidden')
      this.contentTarget.classList.remove('hidden')
    }, this.delayContentVisibilityByMs())
  }

  markSelectorAsSelected(linkUrl) {
    let selectedClasses = this.data.get('selected-class').split(' ')

    this.selectorTargets.forEach(selector => {
      let target = selector.closest('.selected-indicator')
      selectedClasses.forEach(className => {
        target.classList.toggle(className, selector.href === linkUrl)
      })
    })
  }

  delayContentVisibilityByMs() {
    let loadingTime = new Date() - this.startedAt
    if (loadingTime >= this.showLoadingMinimumMs) {
      return 0
    } else {
      return this.showLoadingMinimumMs - loadingTime
    }
  }
}
