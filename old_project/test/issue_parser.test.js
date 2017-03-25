var test  = require('tape');
var parse = require('../handlers/issues_handler.js').parse;
var issues = require('./fixtures/issues.json');

var parsed_issues = parse(issues.entries);

test('Parser returns array of objects', function (t) {

  t.ok(Array.isArray(parsed_issues), 'returns array');

  var are_objects = parsed_issues.every(function (result) {
    return (typeof result === 'object');
  });
  t.ok(are_objects, 'all members are objects');

  t.end();
});


test('Array of objects have both "priority" and "issues" properties', function (t) {

  var has_issue_and_priority_properties = function (result) {
    return result.priority !== undefined && result.issues !== undefined;
  };
  var have_properties = parsed_issues.every(has_issue_and_priority_properties);

  t.ok(have_properties, 'all objects have priority and issues properties');

  t.end();

});


test('parsed issues have expected structure', function(t) {

  function check_issues (priority) {
    return Array.isArray(priority.issues);
  }

  function is_valid_priority (priority) {
    return ['1', '2', '3', '4', '5', 'unprioritised'].some(function(level){
      return level === priority;
    });
  }

  function has_title_and_url (issue) {
    return issue.title !== undefined && issue.url !== undefined;
  }

  var issues_is_array = parsed_issues.every(check_issues);
  t.ok(issues_is_array, '"priority" and "issue" have expected types');

  var valid_priorities = parsed_issues.every(function (priority_level) {
    return is_valid_priority(priority_level.priority);
  });
  t.ok(valid_priorities, 'priorities are valid');

  var valid_issues = parsed_issues.every(function(priority) {
    return priority.issues.length && priority.issues.every(has_title_and_url);
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
