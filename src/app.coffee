# Holy moly. no "var" keywords and no semicolons. That itches a little.
express = require 'express'
compress = require 'compression'
app = express()
module.exports = app
app.cache = {}
util = require 'util'
index = require './routes/index'
server = {}

app.init = (ip = '127.0.0.1', port = 8080) ->
  # Look at me, writing coffee script. Looks sketchy though.

  # Eh. Really? You can chain functions like this? This is unreadable!
  console.log util.format 'App started. Listening on %d', port
  app.opts = {
    ip: ip,
    port: port
  }
  server = app.listen port, ip

# OK, that's kind of readable. Literate.
app.close = () ->
  console.log 'Closing server with the following options:', app.opts
  server.close()


app.use compress()
app.use express.static __dirname + '/../static/dartangular/web', {
  maxAge: 3600000 * 24 * 30
}
app.use express.static __dirname + '/../static/dartangular/build/web', {
  maxAge: 3600000 * 24 * 30
}

# These guys also looks kind of OK.
app.get '/api/userstatus/:user', index.user
app.get '/api/user', index.allusers
app.get '/api/unbook/:user/:id', index.unbook
app.get '/', index.index

# By the way, I like this form of commenting :)
