'use strict'

exports.handler = function(event, context, callback) {
  var response = {
    statusCode: 200,
    headers: {
      'Content-Type': 'text/html; charset=utf-8'
    },
    body: `
      <h2>Event</h2>
      <pre>${JSON.stringify(event, null, 2)}</pre>

      <hr/>

      <h2>Context</h2>
      <pre>${JSON.stringify(context, null, 2)}</pre>
    `
  }
  callback(null, response)
}

