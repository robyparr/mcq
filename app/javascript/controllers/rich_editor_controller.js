import { Controller } from 'stimulus'
import _template from 'lodash/template'
import _compact from 'lodash/compact'

import Quill from 'quill'
import 'quill/dist/quill.snow.css';

export default class extends Controller {
  static targets = [
    'hiddenInput',
    'editorWrapper',
  ]

  hiddenInputTemplate = _template(`
    <input type="hidden"
           name="<%- name %>"
           data-target="<%- target %>"
           value="<%- value %>" />
  `)

  editorWrapperTemplate = _template(`
    <div data-target="rich-editor.editorWrapper"><%= content %></div>
  `)

  connect() {
    this.insertHiddenInput()
    this.renderEditor()
  }

  insertHiddenInput() {
    const targetString = _compact([
      'rich-editor.hiddenInput',
      this.data.get('inputTargets'),
    ]).join(' ')

    const inputTemplate = this.hiddenInputTemplate({
      name:   this.data.get('inputName'),
      target: targetString,
      value:  this.data.get('content'),
    })

    this.element.insertAdjacentHTML('beforeend', inputTemplate)
  }

  renderEditor() {
    const wrapperTemplate = this.editorWrapperTemplate({
      content: this.data.get('content'),
    })

    this.element.insertAdjacentHTML('beforeend', wrapperTemplate)
    this.editor = new Quill(this.editorWrapperTarget, {
      theme: 'snow',
      placeholder: 'Your note...',
      modules: {
        toolbar: [
          [{ header: [] }, { 'font': [] }],
          ['bold', 'italic', 'underline', 'strike', 'code'],
          [{ 'color': [] }, { 'background': [] }],
          [{ list: 'ordered' }, { list: 'bullet' }, { 'align': [] }],
          ['blockquote', 'code-block'],
          ['link', 'image'],
        ],
      },
    })

    this.editor.on('text-change', () => {
      this.hiddenInputTarget.value = this.editor.root.innerHTML
    })
  }
}
