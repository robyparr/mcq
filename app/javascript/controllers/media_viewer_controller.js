import ApplicationController from './application_controller'

export default class extends ApplicationController {
  static targets = [
    'viewerWrap',
    'mediaWrap',
    'loader',
    'media',
  ]

  static templates = {
    article: `
      <iframe src="<%- url %>"
              class="hidden h-full w-full"
              data-target="media-viewer.media"
              data-action="load->media-viewer#urlLoaded" />
    `,

    video: {
      youtube: `
        <iframe type="text/html"
                src="<%- url %>"
                allowfullscreen="allowfullscreen"
                frameborder="1"
                width="640"
                height="390"
                data-target="media-viewer.media"
                data-action="load->media-viewer#urlLoaded" />
      `
    },

    unsupportedService: `
      <div data-target="media-viewer.media" class="fully-centered">
        <div class="text-3xl mb-2">:(</div>
        Sorry, this <%- type %> service isn't supported.
      </div>
    `
  }

  open() {
    const mediaType = this.data.get('type').toLowerCase()
    const mediaService = this.data.get('mediaService')
    let templateName = null
    let templateData = {}
    if (mediaType === 'video') {
      const templateKey = `video.${mediaService.toLowerCase()}`
      if (this.hasTemplate(templateKey)) {
        templateName = templateKey
        const videoId = this.data.get('mediaId')
        const params = _.map({
          autoplay: 0,
          origin: window.location.hostname,
          rel: 0,
        }, (param, value) => `${param}=${value}`).join('&')
        templateData.url = `https://www.youtube.com/embed/${videoId}?${params}`
      }
    } else {
      templateName = 'article'
      templateData = {
        url: this.data.get('url'),
        type: mediaType
      }
    }

    if (templateName) {
      this.renderMedia(templateName, templateData)
    } else {
      this.renderUnsupportedMediaServiceMessage()
    }

    this.viewerWrapTarget.classList.remove('hidden')
  }

  renderMedia(templateName, templateData) {
    this.renderTemplate({
      el: this.mediaWrapTarget,
      name: templateName,
      data: templateData
    })
  }

  renderUnsupportedMediaServiceMessage(mediaType) {
    this.renderTemplate({
      el: this.mediaWrapTarget,
      name: 'unsupportedService',
      data: {
        type: mediaType,
      }
    })
    this.urlLoaded()
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
    this.mediaWrapTarget.classList.remove('hidden')
    this.mediaTarget.classList.remove('hidden')
  }

  hideLoader() {
    this.loaderTarget.classList.add('hidden')
  }
}
