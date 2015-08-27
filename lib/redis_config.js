var redis = require('redis');
var url   = require('url');

var parsed_redis_URL = url.parse(process.env.REDISCLOUD_URL);

function createDbClient(redisURL) {
    var redis_URL = redisURL || parsed_redis_URL;
    var client = redis.createClient(redis_URL.port, redis_URL.hostname, {
        no_ready_check: true
    });
    client.auth(redis_URL.auth.split(":")[1]);
    return client;
}

module.exports = createDbClient;
