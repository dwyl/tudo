"use strict"

var getIssues = require('../lib/get-issues');
var issues = getIssues('assigned', function(error, data) {
    return data;
});

function parseIssues (issues) {

    var issuesArray = issues.map(function(element) {
        return {
            id: element.id,
            created_by: element.user.login,
            org_name: element.url.split('/')[4],
            repo_name: element.url.split('/')[5],
            title: element.title,
            first_line: element.body.substr(0, 100),
            labels: element.labels,
            updated_at: element.updated_at,
            created_at: element.created_at,
            last_comment: element.comment_items[element.comment_items.length - 1],
            number_of_comments: element.comments,
            issue_number: element.number,
            assigness: element.assignee.username
        }
    });

    return issuesArray;
}

module.exports = parseIssues;
