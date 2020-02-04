<template>
  <div class="editor">
    <input type="hidden" name="media_note[content]" v-model="html" />
    <editor-menu-bar :editor="editor" v-slot="{ commands, isActive }">
      <div class="menubar">
        <button class="menubar__button"
                :class="{ 'is-active': isActive.bold() }"
                @click="commands.bold">
          <i class="fas fa-bold"></i>
        </button>

        <button class="menubar__button"
                :class="{ 'is-active': isActive.italic() }"
                @click="commands.italic">
          <i class="fas fa-italic"></i>
        </button>

        <button class="menubar__button"
                :class="{ 'is-active': isActive.strike() }"
                @click="commands.strike">
          <i class="fas fa-strikethrough"></i>
        </button>

        <button class="menubar__button"
                :class="{ 'is-active': isActive.underline() }"
                @click="commands.underline">
          <i class="fas fa-underline"></i>
        </button>

        <button class="menubar__button"
                :class="{ 'is-active': isActive.code() }"
                @click="commands.code">
          <i class="fas fa-code"></i>
        </button>

        <button class="menubar__button"
                :class="{ 'is-active': isActive.paragraph() }"
                @click="commands.paragraph">
          <i class="fas fa-paragraph"></i>
        </button>

        <button class="menubar__button"
                :class="{ 'is-active': isActive.heading({ level: 1 }) }"
                @click="commands.heading({ level: 1 })">
          <i class="fas fa-heading"></i>
        </button>

        <button class="menubar__button"
                :class="{ 'is-active': isActive.heading({ level: 2 }) }"
                @click="commands.heading({ level: 2 })">
          <i class="fas fa-heading"></i>
        </button>

        <button class="menubar__button"
                :class="{ 'is-active': isActive.heading({ level: 3 }) }"
                @click="commands.heading({ level: 3 })">
          <i class="fas fa-heading"></i>
        </button>

        <button class="menubar__button"
                :class="{ 'is-active': isActive.bullet_list() }"
                @click="commands.bullet_list">
          <i class="fas fa-list-ul"></i>
        </button>

        <button class="menubar__button"
                :class="{ 'is-active': isActive.ordered_list() }"
                @click="commands.ordered_list">
          <i class="fas fa-list-ol"></i>
        </button>

        <button class="menubar__button"
                :class="{ 'is-active': isActive.blockquote() }"
                @click="commands.blockquote">
          <i class="fas fa-quote-right"></i>
        </button>

        <button class="menubar__button"
                :class="{ 'is-active': isActive.code_block() }"
                @click="commands.code_block">
          <i class="fas fa-code"></i>
        </button>

        <button class="menubar__button" @click="commands.horizontal_rule">
          hr
        </button>
      </div>
    </editor-menu-bar>

    <editor-content class="editor__content" :editor="editor" />
  </div>
</template>

<script>
import { Editor, EditorContent, EditorMenuBar } from 'tiptap'
import {
  Blockquote,
  CodeBlock,
  HardBreak,
  Heading,
  HorizontalRule,
  OrderedList,
  BulletList,
  ListItem,
  TodoItem,
  TodoList,
  Bold,
  Code,
  Italic,
  Link,
  Strike,
  Underline,
} from 'tiptap-extensions'

export default {
  components: {
    EditorContent,
    EditorMenuBar,
  },
  data() {
    return {
      html: '',
      editor: new Editor({
        content: this.html || 'Type your note here...',
        extensions: [
          new Blockquote(),
          new BulletList(),
          new CodeBlock(),
          new HardBreak(),
          new Heading({ levels: [1, 2, 3] }),
          new HorizontalRule(),
          new ListItem(),
          new OrderedList(),
          new TodoItem(),
          new TodoList(),
          new Link(),
          new Bold(),
          new Code(),
          new Italic(),
          new Strike(),
          new Underline(),
        ],
        onUpdate: ({ getJSON, getHTML }) => {
          this.html = getHTML()
        },
      }),
    }
  },
  beforeDestroy() {
    this.editor.destroy()
  },
}
</script>
