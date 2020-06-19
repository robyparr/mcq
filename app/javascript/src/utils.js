import _defaults from 'lodash/defaults'

export default {
  getAuthenticityToken: function() {
    return document.querySelector('meta[name="csrf-token"]').content
  },

  fetch: function(url, options) {
    _defaults(options, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': this.getAuthenticityToken()
      },
    })

    if (options.body)
      options.body = JSON.stringify(options.body)

    return fetch(url, options)
      .then(response => response.json())
      .then(json => {
        if (json.status == 303) { // Redirect
          window.location = json.location
        } else {
          return json;
        }
      })
  }
}
