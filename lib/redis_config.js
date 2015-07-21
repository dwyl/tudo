var redis = require('redis');

function createDbClient(redisURL) {
    var client = redis.createClient(redisURL.port, redisURL.hostname,
        {
            no_ready_check: true
        });
    if (redisURL.auth) {
        client.auth(redisURL.auth.split(":")[1]);
    }
    return client;
}

module.exports = createDbClient;
