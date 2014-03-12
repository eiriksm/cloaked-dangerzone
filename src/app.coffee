express = require 'express'
util = require 'util'

app = express()
app.init = (port = 1234) ->
  console.log(util.format('App started. Listening on %d', port))
  app.listen(port)

module.exports = app
