var riot          = require('riot');
var views         = require('../views');
var https         = require('https');
var querystring   = require('querystring');
var redis_client  = require('../lib/redis_config')();

function make_post_data (request) {
  return querystring.stringify({
    client_id:     process.env.GITHUB_CLIENT_ID,
    client_secret: process.env.GITHUB_CLIENT_SECRET,
    code:          request.query.code
  });
}

function make_options (post_data) {
  return {
    hostname: 'github.com',
    path: '/login/oauth/access_token',
    method: 'POST',
    headers: {
      'Accept'        : 'application/json',
      'Content-Type'  : 'application/x-www-form-urlencoded',
      'Content-Length': post_data.length
    }
  };
}

/* redis_login_handler stores access_token for later use
 * @param {String} access_json - the string returned by github auth
 * @param {Function} callback - call this when redis replies
 */

function redis_login_handler (access_json, callback) {
  var access_token = 'token ' + JSON.parse(access_json).access_token;
  https.get({
    hostname: 'api.github.com',
    path: '/user',
    method: 'GET',
    headers: {
      authorization: access_token,
      'User-Agent': 'Tudo'
    }
  }, function (res){
    access_token = access_token.split(' ')[1];
    var user_name = '';
    res.setEncoding('utf-8');
    res.on('data', function (chunk){
      user_name += chunk;
    }).on('end', function(){
      user_name = JSON.parse(user_name).login;
      redis_client.hset('tokens', user_name, access_token, callback);
    })
  });
}

function token_response_handler (response) {
  var json_string = '';
  response.setEncoding('utf-8');
  response.on('data', function (chunk){
    json_string += chunk;
  });
  response.on('end', function(){redis_login_handler(json_string)});
}

function get_access_token (request, reply) {
  var post_data = make_post_data(request);
  var options   = make_options(post_data);
  var req = https.request(options, token_response_handler);
  req.write(post_data);
  req.end();
}

function authentication_handler (request, reply) {
  var body = riot.render(views.login);
  reply(views.header + body + views.footer);
  if (request.query && request.query.code) { get_access_token(request, reply); }
}

module.exports = authentication_handler;
module.exports.redis_login_handler = redis_login_handler;
module.exports.redis_client = redis_client;
