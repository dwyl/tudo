var riot = require('riot');
var tags = require('../views/');
var issues_fixture = require("../test/fixtures/issues.json");

function parse (entries) {

  //extract priorities from issue
  function find_priorities(issue) {
    return issue.labels.filter(function(label) {
      return label.match(/priority-\d/);
    });
  }

  //if multiple priority labels are present choose first one or if no priority labels assign to unprioritised
  function decide_priority(priority_array) {
    return priority_array.reduce(function(priority, priority_string) {
      return priority === "unprioritised" ? priority_string.split("-")[1] : priority;
    }, "unprioritised")
  }

  //create object with keys as priority levels and values as arrays of corresponding issues
  var prioritised_issues = entries.reduce(function(prioritised_issues, issue) {

    //selects the highest priority digit for that issue ("unprioritised" if no priority)
    var priority = decide_priority(find_priorities(issue));

    if (!prioritised_issues[priority]) {
      prioritised_issues[priority] = [];
    }

    prioritised_issues[priority].push(issue);

    return prioritised_issues;

  },{});

  //restructure prioritised_issues into an array of objects with priority and issues properties
  var prioritised_array = Object.keys(prioritised_issues).map(function(priority) {
    return {
      priority: priority,
      issues: prioritised_issues[priority]
    }
  });

  return prioritised_array;
}

exports.handler = function (req, reply) {
  reply(tags.prefix + riot.render(tags.issues_page, {prioritised_issues: parse(issues_fixture.entries)}) + tags.suffix);
}

exports.parse = parse;
