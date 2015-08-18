var test  = require("tape");
var server = require('../server');

test('Visit homepage', function(t){
  server.inject({url:'/', method:'GET'}, function(res){
    t.ok(res.payload.indexOf('Welcome to') > -1, 'Homepage has Welcome')
    t.end();
  })
})
