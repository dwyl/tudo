var test = require("tape");
var server = require("../server.js");

var user = "dwyl-dummy";


test("testing getting all issues", function (t) {

    var opts = {
        method: "GET",
        url: "/issues/all"
    }

    server.inject(opts, function (res) {

        var issues = JSON.parse(res.payload);

        t.equal(res.statusCode, 200, "status code is OK");
        t.ok(issues.length > 0, "payload contains one or more issues");
        t.end();
        server.stop();
    });
});


test("testing getting issues assigned to user", function (t) {

    var opts = {
        method: "GET",
        url: "/issues/assigned"
    }

    server.inject(opts, function (res) {

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

    var opts = {
        method: "GET",
        url: "/issues/created"
    }

    server.inject(opts, function (res) {

        var issues = JSON.parse(res.payload);

        t.equal(res.statusCode, 200, "status code is OK");
        t.ok(issues.length > 0, "payload contains one or more issues");
        t.end();
        server.stop();
    });
});


test("testing getting subscribed issues", function (t) {

    var opts = {
        method: "GET",
        url: "/issues/subscribed"
    }

    server.inject(opts, function (res) {

        var issues = JSON.parse(res.payload);

        t.equal(res.statusCode, 200, "status code is OK");
        t.ok(issues.length > 0, "payload contains one or more issues");
        t.end();
        server.stop();
    });
});


test("testing getting issues mentioning user", function (t) {

    var opts = {
        method: "GET",
        url: "/issues/mentioned"
    }

    server.inject(opts, function (res) {

        var issues = JSON.parse(res.payload);

        t.equal(res.statusCode, 200, "status code is OK");
        t.ok(issues.length > 0, "payload contains one or more issues");
        t.end();
        server.stop();
    });
});


test("testing we get an error when non-existent filter applied", function (t) {

    var errorMessage = "Sorry, that option does not exist.";
    var opts = {
        method: "GET",
        url: "/issues/sdfakjals"
    }

    server.inject(opts, function (res) {

        var error = res.result.message;

        t.equal(error, errorMessage, "error message displayed correctly");
        t.end();
        server.stop();
    });
});

// test("issues contain correct information", function (t) {

//     server.inject(opts, function (res) {

//         var issues = JSON.parse(res.payload);

//         t.ok(issues[0].hasOwnProperty("url"), "contains the url to the issue");
//         t.ok(issues[0].hasOwnProperty("labels"), "contains labels prop");
//         t.end();
//         server.stop();
//     });
// });
