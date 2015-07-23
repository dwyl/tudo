var url = require('url');
var redisConfig = require('./redis_config.');
var redisURL = url.parse(process.env.REDISCLOUD_URL);
var pub = redisConfig(redisURL);
var sub = redisConfig(redisURL);

module.exports = {
    pub: pub,
    sub: sub
};
