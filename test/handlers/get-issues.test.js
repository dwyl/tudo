var test = require("tape");
var server = require("../../server.js");

var opts = {
    method: "GET",
    url: "/issues"
};


test("testing getting issues", function (t) {
    server.inject(opts, function (res) {
        var issues = JSON.parse(res.payload);

        t.equal(res.statusCode, 200, "status code is OK");
        t.ok(issues.length > 0, "payload contains one or more issues");
        t.end();
        server.stop();
    });
});

test("issues contain correct information", function (t) {
    server.inject(opts, function (res) {
        var issues = JSON.parse(res.payload);

        t.ok(issues[0].hasOwnProperty("url"), "contains the url to the issue");
        t.ok(issues[0].hasOwnProperty("labels"), "contains labels prop");
        t.end();
        server.stop();
    });
});
