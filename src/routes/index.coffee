config = require 'yaml-config'
app = require '../app'
fs = require 'fs'
users = {}
config_file = './config.yml'

settings = config.readConfig(config_file, 'default');
if !settings.users
  # Try to find some users in env variables.
  if process.env.CLOAKED_USERS
    try
      settings.users = JSON.parse process.env.CLOAKED_USERS
      # We probably do not have the config file. Try to create it.
      fs.open config_file, 'w', (err, fd) ->
        if !err
          # First write the "default" key to the file
          fs.appendFile config_file, 'default:\n', (e) ->
            if !e
              config.updateConfig settings, config_file, 'default'
        # Should do some error handling, I guess. At least we tried, eh?
    catch error
      console.error error

if settings && settings.users
  console.log 'is here'
  console.log settings
  settings.users.forEach (v) ->
    users[v.username] = v

module.exports =
  user: (req, res) ->
    user = req.params.user
    if !users[user]
      res.send 404
      return
    if app.cache[user]
      c = app.cache[user].unix
      if c && c > (Date.now() - 60000)
        res.send app.cache[user]
        return
    # We need to init this per request.
    octo = require 'tripping-octo-nemesis'
    octo.init users[user], false, (err, _) ->
      octo.status (err, result) ->
        if !err
          data = {
            status: result,
            updated: new Date(),
            unix: Date.now()
          }
          app.cache[user] = data
          res.send data
          return
        res.send 500, 'problems'

  allusers: (req, res) ->
    response = []
    settings.users = settings.users || []
    settings.users.forEach (n) ->
      response.push n.username
    res.json(response)

  unbook: (req, res) ->
    user = req.params.user
    id = req.params.id
    octo = require 'tripping-octo-nemesis'
    octo.init users[user], false, (err, _) ->
      octo.unbook id, (e, r) ->
        # This means we need to invalidate the cache.
        delete app.cache[user]
        res.json(r)

  # Index.html sent back on GET /

  index: (req, res) ->
    res.sendfile "static/dartangular/web/index.html"
