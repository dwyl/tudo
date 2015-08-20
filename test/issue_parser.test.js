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

/* CURRENT TEST
test('Array of objects have both "priority" and "issues" properties', function (t) {

});
*/
/* EXPECTED DATA FORMAT OF PARSE
[
  {
    priority: 1,
    issues: [
      {
	title: 'AOEU',
	url: 'http://filwisher.com'
      }
    ]
  }
]
*/
