import _ from 'lodash'

export default {
  getAuthenticityToken: function() {
    return document.querySelector('meta[name="csrf-token"]').content
  },

  fetch: function(url, options) {
    _.defaults(options, {
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
  }
}
