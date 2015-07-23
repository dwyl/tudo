var test             = require("tape");
var parseIssues      = require("../api/parse_issues.js");
var issueArray       = require("../example_issues.json");
var parsedIssues     = require("./fixtures/gh_to_db_parser_fixtures");
var parsedIssueArray = [parsedIssues.parsedIssue1, parsedIssues.parsedIssue2];

test("Array of issues correctly parsed", function (t) {
    t.deepEqual(parseIssues(issueArray), parsedIssueArray);
    t.end();
});
