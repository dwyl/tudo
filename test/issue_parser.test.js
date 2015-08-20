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

test('"priority" and "issue" are of the expected types', function (t) {

  var has_expected_types = function (result) {
    return typeof result.priority === 'number' && Array.isArray(result.issues);
  };
  var have_types = results.every(has_expected_types);

  t.ok(have_types, '"priority" and "issue" have expected types');

  t.end();

});

test('parsed issues have expected structure', function(t) {
  function is_between_1_and_5 (num) {
    return typeof num === 'number' && num >= 1 && num <= 5;
  }
  function has_title_and_url (issue) {
    return issue.title !== undefined && issue.url !== undefined;
  }

  var valid_priorities = results.every(function (result) {
    return is_between_1_and_5(result.priority);
  });
  t.ok(valid_priorities, 'priorities are in expected range');

  var valid_issues = results.every(function(result) {
    return result.issues.length && result.issues.every(has_title_and_url);
  });
  t.ok(valid_issues, 'issues have title and url properties');
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
