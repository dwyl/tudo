require('env2')('config.env');
var test         = require('tape');
var server       = require('../server'); // test server which in turn loads our module
var redis_client  = require('../lib/redis_config')();
var authentication_handler = require('../handlers/authentication_handler');

test("GitHub Authentication Test [WiP!]", function(t) {
  var options = {
    method: "GET",
    url: "/login"
  };
  // server.inject lets us similate an http request
  server.inject(options, function(response) {
    t.equal(response.statusCode, 200, "Login Page Rendered");
    // t.equal(response.result, '<hello>Hello Benji!</hello>', "Response is Hello Benji!")
    server.stop(function(){}); // stop requires callback!
    t.end();
  });
});

test('I am not sure how to write sensible tests for auth', function (t) {
  server.ext('onPreAuth', function (req, rep) {
    req.query = {code: 1};
    rep.continue();
  });
  server.inject({method: 'GET', url: '/login'}, function (res) {
    server.stop(function(){});
    t.end();
  });
});

test('Checks that redis_login_handler correctly inserts authentication token', function (t) {
  // console.log(process.env.ACCESS_JSON);
  authentication_handler.redis_login_handler(process.env.ACCESS_JSON, function(err, data){
    var access_token = JSON.parse(process.env.ACCESS_JSON).access_token;
    var dummy_auth_token = redis_client.hget('tokens', 'dwyl-dummy', function (err, data) {
      t.equal(data, access_token);
      redis_client.end();
      authentication_handler.redis_client.end();
      t.end();
    });
  });
})
