// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
import "@hotwired/turbo-rails"
// require("@rails/activestorage").start()
// require("channels")

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import "controllers"

import 'bootstrap-icons/font/bootstrap-icons.css'

import tippy from 'tippy.js'
import 'tippy.js/dist/tippy.css'

const renderTippy = () => tippy('[data-tippy-content]', { interactive: true })
document.addEventListener('DOMContentLoaded', renderTippy)
document.addEventListener('ajax:success', renderTippy)
document.addEventListener('turbo_link_to:afterclick', renderTippy)
