var test        = require("tape");
var fetchIssues = require ("../lib/fetch_issues_by_user.js");
var redisClient = require("./redis_test_client.js")();
var DB          = require("../lib/db_handlers.js");

test("Add user and then get the expected issues back straight from db", function (t) {
  DB.addUser(redisClient, {username: "dwyl-dummy"}, function (err, reply) {

    DB.addIssuesByUsername(redisClient, "dwyl-dummy", [], function (err, reply) {

      fetchIssues(redisClient, "dwyl-dummy", function (err, data) {

        t.equal(data.length, 0, 'should be empty array');

        var multi = redisClient.multi();
        multi.del("dwyl-dummy:issues");
        multi.del("user:dwyl-dummy");
        multi.srem("users", "dwyl-dummy");
        multi.exec(function (err, replies) {
          t.end();
        });
      });
    });
  });
});

test("Get issues for user that does not exist i.e. from github", function (t) {
  fetchIssues(redisClient, "dwyl-dummy", function (err, data) {

    t.ok(data.length>0, "expect there to be at least one issue for dummy user");

    DB.getIssuesByUsername(redisClient, "dwyl-dummy", function(err, issues) {
      t.equal(data.toString(), issues.toString());

      var multi = redisClient.multi();

      multi.del("dwyl-dummy:issues");
      multi.del("user:dwyl-dummy");
      multi.srem("users", "dwyl-dummy");
      multi.exec(function (err, replies) {
        t.end();
      });
    });
  });
});

test("Close clients after tests completed", function (t) {
  redisClient.end()
  t.end();
});
