import Vue from 'vue/dist/vue.esm'
import RichEditor from '../src/rich_editor'

window.renderRichEditor = function(el) {
  new Vue({
    el: el,
    components: { RichEditor }
  })
}
