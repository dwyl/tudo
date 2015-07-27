var fixtures = {};
var parsedIssues = require('./gh_to_db_parser_fixtures.js')
fixtures.category = "assigned";
fixtures.parsedIssueArray = [parsedIssues.parsedIssue1, parsedIssues.parsedIssue2];

module.exports = fixtures;
