var test   = require('tape');
var server = require('../../server.js'); // test server which in turn loads our module

test("Hello World Test!", function(t) {
  var options = {
    method: "GET",
    url: "/hello/Benji"
  };
  // server.inject lets us similate an http request
  server.inject(options, function(response) {

    t.equal(response.statusCode, 200, "Everything Works as expected!");
    t.equal(response.result, '<hello>Hello Benji!</hello>', "Response is Hello Benji!")
    t.end();
    server.stop();
  });
});
