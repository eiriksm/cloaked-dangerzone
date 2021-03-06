# Mock the env variable

request = require 'supertest'
should = require 'should'
app = require '../lib/app'
app.init()
app.setOcto {
  init: (a, b, callback) ->
    callback()
}

describe 'App', ->
  it 'Should do something', (done) ->
    app.should.be.instanceof(Function)
    app.init.should.be.instanceof(Function)
    done()

  it 'Should answer on GET /', (done) ->
    request(app)
    .get '/'
    .set('Authorization', 'Basic dGVzdG5hbWVAdGVzdC5jb206Ym9ndXM=')
    .end (err, a) ->
      a.statusCode.should.equal 200
      done(err)

  it 'Should give us something on GET /api/user', (done) ->
    request app
    .get '/api/user'
    .set('Authorization', 'Basic dGVzdG5hbWVAdGVzdC5jb206Ym9ndXM=')
    .end (err, a, b) ->
      a.statusCode.should.equal 200
      a.body[0].should.equal 'testname@test.com'
      done(err)

  upd = new Date()

  it 'Should give us something on GET /api/userstatus/<user>', (done) ->
    this.timeout 10000
    request app
    .get '/api/userstatus/testname@test.com'
    .set('Authorization', 'Basic dGVzdG5hbWVAdGVzdC5jb206Ym9ndXM=')
    .end (err, a, b) ->
      a.statusCode.should.equal 200
      a.body.status.should.equal false
      upd = a.body.updated
      done(err)

  it 'Should give us the same something on GET /api/userstatus/<user>', (done) ->
    request app
    .get '/api/userstatus/testname@test.com'
    .set('Authorization', 'Basic dGVzdG5hbWVAdGVzdC5jb206Ym9ndXM=')
    .end (err, a, b) ->
      a.statusCode.should.equal 200
      a.body.status.should.equal false
      a.body.updated.should.equal upd
      done(err)

  it 'Should give us 404 on non existing user', (done) ->
    request app
    .get '/api/userstatus/bogus' + Math.random()
    .set('Authorization', 'Basic dGVzdG5hbWVAdGVzdC5jb206Ym9ndXM=')
    .end (err, a) ->
      a.statusCode.should.equal 404
      done(err)

  it 'Should happen something if we init all over again', (done) ->
    process.env.CLOAKED_USERS = '[{"username":"testname@test.com","password":"bogus" BLARGH = ]]}]'
    app.close()
    app.init(12321, 45654)
    done()
