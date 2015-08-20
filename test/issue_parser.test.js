var test  = require('tape');
var parse = require('../handlers/issues_handler.js').parse;
var issues = require('./fixtures/issues.json')

var results = parse(issues);

test('Parser returns array of objects', function (t) {

  t.ok(Array.isArray(parse(issues)), 'returns array');

  var are_objects = results.every(function (result) {
    return (typeof result === 'object');
  });
  t.ok(are_objects, 'all members are objects');

  t.end();
});


test('Array of objects have both "priority" and "issues" properties', function (t) {

  var has_issue_and_priority_properties = function (result) {
    return result.priority !== undefined && result.issues !== undefined;
  };
  var have_properties = results.every(has_issue_and_priority_properties);
  
  t.ok(have_properties, 'all objects have priority and issues properties');

  t.end();

});



//  EXPECTED DATA FORMAT OF PARSE
// [
//   {
//     priority: 1,
//     issues: [
//       {
// 	title: 'AOEU',
// 	url: 'http://filwisher.com'
//       }
//     ]
//   }
// ]

