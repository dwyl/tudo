var test    = require("tape");
var wreck   = require("wreck");
var server  = require("../server.js");
var user    = "dwyl-dummy";

function getOptions (filter) {
    var opts = {
        method: "GET",
        url: "/issues/" + filter
    }

    return opts;
}

test("testing getting all issues", function (t) {

    server.inject( getOptions("all"), function (res) {

        var issues = JSON.parse(res.payload);

        t.equal(res.statusCode, 200, "status code is OK");
        t.ok(issues.length > 0, "payload contains one or more issues");
        t.end();

        server.stop();
    });
});


test("testing getting issues assigned to user", function (t) {

    server.inject(getOptions("assigned"), function (res) {

        var issues = JSON.parse(res.payload);
        var assignedUser = issues[0].assignee.login;

        t.equal(res.statusCode, 200, "status code is OK");
        t.ok(issues.length > 0, "payload contains one or more issues");
        t.equal(assignedUser, user, "issues are correctly assigned to the user");
        t.end();

        server.stop();
    });
});


test("testing getting issues created by the user", function (t) {

    server.inject( getOptions("created"), function (res) {

        var issues = JSON.parse(res.payload);
        var creator = issues[0].user.login;

        t.equal(res.statusCode, 200, "status code is OK");
        t.ok(issues.length > 0, "payload contains one or more issues");
        t.equal(creator, user, "issues are correctly assigned to the user");
        t.end();

        server.stop();
    });
});


test("testing getting subscribed issues", function (t) {

    server.inject( getOptions("subscribed"), function (res) {

        var issues = JSON.parse(res.payload);
        var subscribersUrl = issues[0].repository.subscribers_url;
        var wreckOptions = {
            json: true,
            headers: {
                'Authorization': 'token ' + process.env.GITHUB_KEY,
                'User-Agent': ""
            }
        }

        t.equal(res.statusCode, 200, "status code is OK");
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

            server.stop();
        });
    });
});


test("testing getting issues mentioning user", function (t) {

    server.inject( getOptions("mentioned"), function (res) {
        var issues = JSON.parse(res.payload);

        t.equal(res.statusCode, 200, "status code is OK");
        t.ok(issues.length > 0, "payload contains one or more issues");
        t.ok(issues[0].body.indexOf(user), "user was mentioned in the body");

        t.end();

        server.stop();
    });
});


test("testing we get an error when non-existent filter applied", function (t) {
    var errorMessage = "Sorry, that option does not exist.";

    server.inject( getOptions("sdfakjals"), function (res) {
        var error = res.result.message;

        t.equal(error, errorMessage, "error message displayed correctly");
        t.end();

        server.stop();
    });
});
