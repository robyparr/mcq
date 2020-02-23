import ApplicationController from './application_controller'

export default class extends ApplicationController {
  static targets = [
    'viewerWrap',
    'loader',
    'media',
  ]

  static templates = {
    default: `
      <div class="w-full h-full relative">
        <div class="toolbar mb-0 justify-end py-1 px-4">
          <button data-action="click->media-viewer#close">
            <i class="fas fa-times"></i>
          </button>
        </div>

        <div data-target="media-viewer.loader" class="fully-centered">
          <i class="fas fa-spinner fa-pulse fa-3x"></i>
          <span class="text">Loading page...</span>
        </div>

        <iframe src="<%- url %>"
                class="hidden h-full w-full"
                data-target="media-viewer.media"
                data-action="load->media-viewer#urlLoaded" />
      </div>
    `
  }

  open() {
    this.renderTemplate({
      el: this.viewerWrapTarget,
      name: 'default',
      data: {
        url: this.data.get('url')
      }
    })

    this.viewerWrapTarget.classList.remove('hidden')
  }

  close() {
    this.viewerWrapTarget.classList.add('hidden')
    this.viewerWrapTarget.innerHTML = ''
  }

  urlLoaded() {
    this.hideLoader()
    this.showMedia()
  }

  showMedia() {
    this.mediaTarget.classList.remove('hidden')
  }

  hideLoader() {
    this.loaderTarget.classList.add('hidden')
  }
}
