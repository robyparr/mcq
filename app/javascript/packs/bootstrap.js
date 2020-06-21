import '../src/tailwind/application.css'

window.$ = function(selector) {
  var elements = document.querySelectorAll(selector)

  return Array.from(elements)
}

window.$find = function(selector) {
  return document.querySelector(selector)
}
