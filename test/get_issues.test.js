var test        = require("tape");
var wreck       = require("wreck");
var getIssues   = require("../lib/get_issues.js");

var user        = "dwyl-dummy";

test("testing we get the comments in the issue object", function (t) {

    var filter = "assigned";

    getIssues(filter, function (err, issues) {

        t.ok(issues[0].hasOwnProperty("comment_items"), "payload contains comments content");
        t.end();
    });
});


test("testing getting all issues", function (t) {

    var filter = "all";

    getIssues(filter, function (err, issues) {

        t.ok(issues.length > 0, "payload contains one or more issues");
        t.end();
    });
});


test("testing getting issues assigned to user", function (t) {

    var filter = "assigned";

    getIssues(filter, function (err, issues) {

        var assignedUser = issues[0].assignee.login;

        t.ok(issues.length > 0, "payload contains one or more issues");
        t.equal(assignedUser, user, "issues are correctly assigned to the user");
        t.end();
    });
});


test("testing getting issues created by the user", function (t) {

    var filter = "created";

    getIssues(filter, function (err, issues) {

        var creator = issues[0].user.login;

        t.ok(issues.length > 0, "payload contains one or more issues");
        t.equal(creator, user, "issues are correctly assigned to the user");
        t.end();
    });
});


test("testing getting subscribed issues", function (t) {

    var filter = "subscribed";

    getIssues(filter, function (err, issues) {

        var subscribersUrl = issues[0].repository.subscribers_url;
        var wreckOptions = {
            json: true,
            headers: {
                'Authorization': 'token ' + process.env.GITHUB_KEY,
                'User-Agent': ""
            }
        }

        t.ok(issues.length > 0, "payload contains one or more issues");

        // Fetching data from the subscription endpoint
        wreck.get(subscribersUrl, wreckOptions, function (err, res, payload) {

            var i;
            var length = payload.length;
            var testUser;

            for (i = length - 1; i >= 0; i--) {

                if (payload[i].login === user) {
                    testUser = payload[i].login;
                }
            }

            t.equal(testUser, user, "user exists on the list of subscribers");
            t.end();
        });
    });
});


test("testing getting issues mentioning user", function (t) {

    var filter = "mentioned";

    getIssues(filter, function (err, issues) {

        t.ok(issues.length > 0, "payload contains one or more issues");
        t.ok(issues[0].body.indexOf(user), "user was mentioned in the body");
        t.end();
    });
});


test("testing we get an error when non-existent filter applied", function (t) {

    var filter = "dfakjals";

    getIssues(filter, function (err, issues) {

        var errorMessage = "Sorry, that option does not exist.";

        t.equal(err.message, "Validation Failed", "error message displayed correctly");
        t.end();
    });
});
