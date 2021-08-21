import ApplicationController from './application_controller'
import _map from 'lodash/map'

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
    this.renderMedia()
    this.showViewer()
  }

  close() {
    this.viewerWrapTarget.classList.add('hidden')
    this.mediaWrapTarget.innerHTML = ''
    this.showLoader()
  }

  urlLoaded() {
    this.hideLoader()
    this.showMedia()
  }

  renderMedia() {
    const mediaType    = this.data.get('type').toLowerCase()
    const mediaService = this.data.get('mediaService')

    const templateName = this.getTemplateName(mediaType, mediaService)
    const templateData = this.buildTemplateData(mediaType)

    if (!templateName)
      return this.renderUnsupportedMediaServiceMessage()

    this.renderTemplate({
      el: this.mediaWrapTarget,
      name: templateName,
      data: templateData
    })
  }

  getTemplateName(mediaType, mediaService) {
    let templateName = null

    if (mediaType === 'video') {
      const templateKey = `video.${mediaService.toLowerCase()}`
      if (this.hasTemplate(templateKey)) {
        templateName = templateKey
      }
    } else {
      templateName = 'article'
    }

    return templateName
  }

  buildTemplateData(mediaType) {
    let templateData = {}

    if (mediaType === 'video') {
      const params = _map({
        autoplay: 0,
        origin: window.location.hostname,
        rel: 0,
      }, (param, value) => `${param}=${value}`).join('&')
      const videoId = this.data.get('mediaId')
      templateData.url = `https://www.youtube.com/embed/${videoId}?${params}`
    } else {
      templateData = {
        url: this.data.get('url'),
        type: mediaType
      }
    }

    return templateData;
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

  showMedia() {
    this.mediaWrapTarget.classList.remove('hidden')
    this.mediaTarget.classList.remove('hidden')
  }

  hideLoader() {
    this.loaderTarget.classList.add('hidden')
  }

  showLoader() {
    this.loaderTarget.classList.remove('hidden')
  }

  showViewer() {
    this.viewerWrapTarget.classList.remove('hidden')
  }
}
