require('env2')('config.env'); // require config
var test = require("tape");
var rc   = require("../lib/redis_config");
var url  = require('url');


test("Connecting to local database", function (t) {
  var connection  = url.parse(process.env.REDISCLOUD_URL);
  var redisClient = rc(connection);
  t.equal(redisClient.address, connection.host, 'Database connects locally to: ' + redisClient.address);
  redisClient.set('TEST', 'REMOTE');
  redisClient.get('TEST', function (err, reply) {
    t.equal(reply, 'REMOTE', 'Database sets and gets correctly');
    redisClient.del('TEST');
    redisClient.end();
    t.end();
  })
});
