require('env2');
var url = require('url');
var redisConfig = require('../lib/redis_config.js');
var redisURL = url.parse(process.env.REDISCLOUD_URL);


module.exports = function createClient () {
    var client = redisConfig(redisURL);
    return client;
}
