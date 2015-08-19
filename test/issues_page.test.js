var test  = require("tape");
var server = require('../server');

test('Visit issues page', function(t){
  server.inject({url:'/issues', method:'GET'}, function(res){
    console.log(' - - - - - - - - - - - - - - - - - - - - -');
    console.log(res.payload);
    console.log(' - - - - - - - - - - - - - - - - - - - - -');
    t.ok(res.payload.indexOf('Priority') > -1, 'Issues page has the word "Priority"');
    server.stop(function(){});
    t.end();
  });
});

test('The 5 priority levels appear on the page', function(t){
  server.inject({url:'/issues', method:'GET'}, function(res){
    
    var priority_nums = [1,2,3,4,5];
    
    //passes each element in array as the 'level' into the callback
    //every returns true or false
    var all_present = priority_nums.every(function(level){
      return res.payload.indexOf('p' + level) > -1;
    })
    
    t.ok(all_present, 'All different priority levels are present');
  
    // t.ok(res.payload.indexOf('Priority') > -1, 'Issues page has the word "Priority"');
    server.stop(function(){});
    t.end();
  });
});





