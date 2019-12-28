import Vue from 'vue/dist/vue.esm'
import UrlViewer from '../src/url_viewer'

document.addEventListener('click', (e) => {
  const urlViewerTarget = e.target.dataset.urlViewer

  if (!urlViewerTarget)
    return

  new Vue({
    el:         urlViewerTarget,
    components: { UrlViewer }
  })
})
