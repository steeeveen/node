var express = require('express'),
    http = require('http'),
    redis = require('redis');

var app = express();

console.log(process.env.EC21 + ':' + process.env.REDIS_PORT_6379_TCP_PORT);

// APPROACH 1: Using environment variables created by Docker
var client = redis.createClient('6379',process.env.REDISDB);
//var client = redis.createClient();


// APPROACH 2: Using host entries created by Docker in /etc/hosts (RECOMMENDED)
//var client = redis.createClient('6379', 'redis_redis_1');


app.get('/', function(req, res, next) {
  client.incr('counter', function(err, counter) {
    if(err) return next(err);
    res.send('This page has been viewed ' + counter + ' times! ' + 'Page served by container ' + process.env.HOSTNAME);
  });
});

http.createServer(app).listen(process.env.PORT || 8080, function() {
  console.log('Listening on port ' + (process.env.PORT || 8080));
});
