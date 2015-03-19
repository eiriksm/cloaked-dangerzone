require('newrelic');
var ip = process.env.OPENSHIFT_NODEJS_IP || '0.0.0.0';
var port = process.env.PORT || 8080;
require('./lib/app').init(ip, port);
