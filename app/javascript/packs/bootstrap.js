import '../src/tailwind/application.css'

window.$ = function(selector) {
  var elements = document.querySelectorAll(selector)

  if (elements.length === 1)
    return elements[0]

  return Array.from(elements)
}
