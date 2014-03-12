request = require 'supertest'
should = require 'should'
app = require '../lib/app'

describe 'App', ->
  it 'Should do something', (done) ->
    app.should.be.instanceof(Function)
    app.init.should.be.instanceof(Function)
    done()

  it 'Should answer on GET /', (done) ->
    request(app)
    .get '/'
    .end (err) ->
      done(err)


