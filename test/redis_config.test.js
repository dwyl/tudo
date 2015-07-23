require('../lib/env.js')
var test        = require("tape");
var redisConfig = require("../lib/redis_config");
var url         = require('url');


test("Connecting to local database", function (t) {
    var connection = url.parse(process.env.TEST_REDISCLOUD_URL);
    var redisClient = redisConfig(connection);
    t.equal(redisClient.address, 'pub-redis-15236.eu-west-1-2.2.ec2.garantiadata.com:15236', 'Database connects locally to: ' + redisClient.address);
    redisClient.set('TEST', 'REMOTE');
    redisClient.get('TEST', function (err, reply) {
        t.equal(reply, 'REMOTE', 'Database sets and gets correctly');
        redisClient.del('TEST');
        redisClient.end();
        t.end();
    })
});
