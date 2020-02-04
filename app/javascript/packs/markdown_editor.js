import Vue from 'vue/dist/vue.esm'
import MarkdownEditor from '../src/markdown_editor'

window.renderMarkdownEditor = function(el) {
  new Vue({
    el: el,
    components: { MarkdownEditor }
  })
}
