# Mock the env variable
process.env.CLOAKED_USERS = '[{"username":"testname@test.com","password":"bogus"}]'

request = require 'supertest'
should = require 'should'
app = require '../lib/app'
app.init()

describe 'App', ->
  it 'Should do something', (done) ->
    app.should.be.instanceof(Function)
    app.init.should.be.instanceof(Function)
    done()

  it 'Should answer on GET /', (done) ->
    request(app)
    .get '/'
    .end (err, a) ->
      a.statusCode.should.equal 200
      done(err)

  it 'Should give us something on GET /api/user', (done) ->
    request app
    .get '/api/user'
    .end (err, a, b) ->
      a.statusCode.should.equal 200
      a.body[0].should.equal 'testname@test.com'
      done(err)

  upd = new Date()

  it 'Should give us something on GET /api/userstatus/<user>', (done) ->
    this.timeout 10000
    request app
    .get '/api/userstatus/testname@test.com'
    .end (err, a, b) ->
      a.statusCode.should.equal 200
      a.body.status.length.should.equal 0
      upd = a.body.updated
      done(err)

  it 'Should give us the same something on GET /api/userstatus/<user>', (done) ->
    request app
    .get '/api/userstatus/testname@test.com'
    .end (err, a, b) ->
      a.statusCode.should.equal 200
      a.body.status.length.should.equal 0
      a.body.updated.should.equal upd
      done(err)

  it 'Should give us 404 on non existing user', (done) ->
    request app
    .get '/api/userstatus/bogus' + Math.random()
    .end (err, a) ->
      a.statusCode.should.equal 404
      done(err)
