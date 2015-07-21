var test = require("tape");
var redisConfig = require("../lib/redis_config");

test("Connecting to local database", function (t) {
    var connection = {
        port: 6379,
        host: '127.0.0.1'
    };
    var authConnection = {
        port: 6379,
        host: '127.0.0.1',
        auth: "thisIsNotSecrets"
    };
    var redisClient = redisConfig(connection);
    var authClient = redisConfig(authConnection);
    t.equal(redisClient.address, '127.0.0.1:6379', 'Database connects locally to: ' + redisClient.address);
    t.equal(authClient.address, '127.0.0.1:6379', 'Authorised database client connects locally to: ' + redisClient.address);
    redisClient.set('TEST', 'LOCAL');
    redisClient.get('TEST', function (err, reply) {
        t.equal(reply, 'LOCAL', 'Database sets and gets correctly');
    })
    authClient.set('TEST', 'LOCAL');
    authClient.get('TEST', function (err, reply) {
        t.equal(reply, 'LOCAL', 'Authorised database sets and gets correctly');
        redisClient.end();
        authClient.end();
        t.end();
    })
});
