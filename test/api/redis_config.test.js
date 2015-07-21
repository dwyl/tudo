var test = require("tape");
var redisConfig = require("../../lib/redis_config");

test("Connecting to local database", function (t) {
    var connection =
        {
            port: 6379,
            host: '127.0.0.1'
        };
    var redisClient = redisConfig(connection);
    t.equal(redisClient.address, '127.0.0.1:6379', 'Database connects locally to: ' + redisClient.address);
    redisClient.set('TEST', 'LOCAL');
    redisClient.get('TEST', function(err, reply){
        t.equal(reply, 'LOCAL', 'Database sets and gets correctly');
    })
    t.end();
});
