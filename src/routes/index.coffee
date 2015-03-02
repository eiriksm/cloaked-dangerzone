app = require '../app'
_ = require 'underscore'

settings = app.settings

module.exports =
  user: (req, res) ->
    user = req.params.user
    if !app.users[user]
      res.sendStatus 404
      return
    if app.cache[user]
      c = app.cache[user].unix
      if c && c > (Date.now() - 60000)
        res.send app.cache[user]
        return
    # We need to init this per request.
    octo = require 'tripping-octo-nemesis'
    octo.init app.users[user], false, (err, _) ->
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
        res.sendStatus 500, 'problems'

  allusers: (req, res) ->
    if app.users[req.user]
      res.send [req.user]
    else
      res.sendStatus 404

  unbook: (req, res) ->
    user = req.params.user
    id = req.params.id
    octo = require 'tripping-octo-nemesis'
    octo.init app.users[user], false, (err, initRes) ->
      octo.unbook id, (e, r) ->
        # This means we need to invalidate the cache.
        delete app.cache[user]
        res.json(r)

  # Index.html sent back on GET /

  index: (req, res) ->
    res.sendfile "static/dartangular/web/index.html"
