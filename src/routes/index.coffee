octo = require 'tripping-octo-nemesis'
config = require 'yaml-config'
app = require '../app'
users = {}

settings = config.readConfig('./config.yml');
if !settings.users
  # Try to find some users in env variables.
  if process.env.CLOAKED_USERS
    console.log 'Trying environment variables for users'
    try
      settings.users = JSON.parse process.env.CLOAKED_USERS
    catch error

if settings && settings.users
  settings.users.forEach (v) ->
    users[v.username] = v

module.exports =
  user: (req, res) ->
    user = req.params.user
    if !users[user]
      res.send 404
      return
    if app.cache[user]?.updated?.getTime() < (new Date().getTime() + 60000)
      res.send app.cache[user]
      return
    octo.init users[user], false, (err, _) ->
      octo.status (err, result) ->
        if !err
          data = {
            status: result,
            updated: new Date()
          }
          app.cache[user] = data
          res.send data
          return
        res.send 500, 'problems'

  allusers: (req, res) ->
    response = []
    settings.users.forEach (n) ->
      response.push n.username
    res.json(response)

  # Index.html sent back on GET /

  index: (req, res) ->
    res.sendfile "static/dartangular/web/index.html"
