// Generated by CoffeeScript 1.7.1
(function() {
  var app, request, should;

  request = require('supertest');

  should = require('should');

  app = require('../lib/app');

  app.init();

  describe('App', function() {
    var upd;
    it('Should do something', function(done) {
      app.should.be["instanceof"](Function);
      app.init.should.be["instanceof"](Function);
      return done();
    });
    it('Should answer on GET /', function(done) {
      return request(app).get('/').set('Authorization', 'Basic dGVzdG5hbWVAdGVzdC5jb206Ym9ndXM=').end(function(err, a) {
        a.statusCode.should.equal(200);
        return done(err);
      });
    });
    it('Should give us something on GET /api/user', function(done) {
      return request(app).get('/api/user').set('Authorization', 'Basic dGVzdG5hbWVAdGVzdC5jb206Ym9ndXM=').end(function(err, a, b) {
        a.statusCode.should.equal(200);
        a.body[0].should.equal('testname@test.com');
        return done(err);
      });
    });
    upd = new Date();
    it('Should give us something on GET /api/userstatus/<user>', function(done) {
      this.timeout(10000);
      return request(app).get('/api/userstatus/testname@test.com').set('Authorization', 'Basic dGVzdG5hbWVAdGVzdC5jb206Ym9ndXM=').end(function(err, a, b) {
        a.statusCode.should.equal(200);
        a.body.status.length.should.equal(0);
        upd = a.body.updated;
        return done(err);
      });
    });
    it('Should give us the same something on GET /api/userstatus/<user>', function(done) {
      return request(app).get('/api/userstatus/testname@test.com').set('Authorization', 'Basic dGVzdG5hbWVAdGVzdC5jb206Ym9ndXM=').end(function(err, a, b) {
        a.statusCode.should.equal(200);
        a.body.status.length.should.equal(0);
        a.body.updated.should.equal(upd);
        return done(err);
      });
    });
    it('Should give us 404 on non existing user', function(done) {
      return request(app).get('/api/userstatus/bogus' + Math.random()).set('Authorization', 'Basic dGVzdG5hbWVAdGVzdC5jb206Ym9ndXM=').end(function(err, a) {
        a.statusCode.should.equal(404);
        return done(err);
      });
    });
    return it('Should happen something if we init all over again', function(done) {
      process.env.CLOAKED_USERS = '[{"username":"testname@test.com","password":"bogus" BLARGH = ]]}]';
      app.close();
      app.init(12321, 45654);
      return done();
    });
  });

}).call(this);
