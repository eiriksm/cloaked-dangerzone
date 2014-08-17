# Holy moly. no "var" keywords and no semicolons. That itches a little.
express = require 'express'
compress = require 'compression'
auth = require 'http-auth'
octo = require 'tripping-octo-nemesis'

app = express()

app.users = {}
module.exports = app

basic = auth.basic {
  realm: '3t login'
}, (username, password, callback) ->
  if !app.users[username]
    octo.init {username: username, password: password}, false, (err, _) ->
      if !err
        callback true
        app.users[username] = {
          password: password,
          username: username
        }
        return
      callback false
      return
    return
  callback app.users[username] && app.users[username].password.toString() == password.toString()
app.use auth.connect basic
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
