import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
import UrlViewer from '../src/url_viewer'

Vue.use(TurbolinksAdapter)

document.addEventListener('click', (e) => {
  const target = e.target
  const urlViewerTarget = target.dataset.urlViewer

  if (!urlViewerTarget)
    return

  const urlViewer = new Vue({
    el: urlViewerTarget,
    components: { UrlViewer }
  })
})
