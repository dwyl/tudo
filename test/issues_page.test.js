var test  = require("tape");
var server = require('../server');

test('Visit issues page', function(t){
  server.inject({url:'/issues', method:'GET'}, function(res){
    t.ok(res.payload.indexOf('Priority') > -1, 'Issues page has the word "Priority"');
    server.stop(function(){});
    t.end();
  });
});
