octo = require 'tripping-octo-nemesis'
config = require 'yaml-config'
app = require '../app'

settings = config.readConfig('./config.yml');

module.exports =
  user: (req, res) ->
    user = req.params.user
    if !settings[user]
      res.send 404
      return
    if app.cache[user]?.updated?.getTime() < (new Date().getTime() + 60000)
      res.send app.cache[user]
      return
    octo.init settings[user], false, (err, _) ->
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

  # Index.html sent back on GET /

  index: (req, res) ->
    res.sendfile "static/dartangular/web/index.html"
