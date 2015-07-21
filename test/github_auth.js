var test   = require('tape');
var server = require('../server'); // test server which in turn loads our module

test("GitHub Authentication Test [WiP!]", function(t) {
  var options = {
    method: "GET",
    url: "/login"
  };
  // server.inject lets us similate an http request
  server.inject(options, function(response) {
    t.equal(response.statusCode, 200, "Login Page Rendered");
    // t.equal(response.result, '<hello>Hello Benji!</hello>', "Response is Hello Benji!")
    server.stop()
    t.end();
  });
});
