# Holy moly. no "var" keywords and no semicolons. That itches a little.
express = require 'express'
app = express()
module.exports = app
app.cache = {}
util = require 'util'
index = require './routes/index'



app.init = (port = 1234) ->
  # Look at me, writing coffee script. Looks sketchy though.

  # Eh. Really? You can chain functions like this? This is unreadable!
  console.log util.format 'App started. Listening on %d', port
  app.listen port

# OK, that's kind of readable. Literate.
app.use app.router
app.use express.static __dirname + '/../static/dartangular/web'
app.use express.static __dirname + '/../static/dartangular/build/web'

# These guys also looks kind of OK.
app.get '/api/user/:user', index.user
app.get '/', index.index

# By the way, I like this form of commenting :)
