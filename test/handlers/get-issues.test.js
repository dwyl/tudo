var test = require("tape");
var server = require("../../issuesAPI/server.js");

var opts = {
    method: "GET",
    url: "/issues/jrans"
};

server.inject(opts, function (res) {

    test("testing getting issues", function (t) {
        var issues = res.payload;

        t.equal(res.statusCode, 200, "status code is OK");
        t.equal(issues.length > 0, true, "payload contains one or more issues");
        t.end();
    });

    test("issues contain correct information", function (t) {
        var issue = res.payload[0];

        t.equal(issue.url.hasOwnProperty("url"), true, "contains the url to the issue");
        t.equal(issue.url.hasOwnProperty("labels"), true, "contains labels prop");
        t.end();
    });
});
