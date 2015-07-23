require('../lib/env.js');
var test        = require("tape");
var url         = require('url');
var redisConfig = require("../lib/redis_config");
var DBHandlers  = require("../api/db_handlers.js");
var fixtures    = require('./fixtures/db_handlers_fixtures.js');
var testUser = fixtures.testUser;
var testIssue1 = fixtures.testIssue1;
var testIssue2 = fixtures.testIssue2;
var testIssue3 = fixtures.testIssue3;
var connection  = url.parse(process.env.TEST_REDISCLOUD_URL);
var redisClient = redisConfig(connection);

test("Adding a user to DB", function (t) {
    DBHandlers.addUser(redisClient, testUser, function (errors, replies) {
        t.equal(errors, null, "add errors null");
        t.deepEqual(replies, ["OK",1], "should get an OK from setting hash, and 1 for addition to set of users");
        redisClient.del("user:" + testUser.username);
        redisClient.srem("users", testUser.username);
        t.end();
    });
});

test("Get user by username", function (t) {
    DBHandlers.addUser(redisClient, testUser, function (errors, replies) {
        DBHandlers.getUserByUsername(redisClient, testUser.username, function(errors, replies) {
            t.deepEqual(replies, testUser);
            redisClient.del("user:" + testUser.username);
            redisClient.srem("users", testUser.username);
            t.end();
        });
    });
});

test("check user exists after adding" , function(t) {
    DBHandlers.addUser(redisClient, testUser, function (errors, replies) {
        DBHandlers.checkUserExists(redisClient, testUser.username, function(err, reply) {
            t.equal(reply,1);
            redisClient.del("user:" + testUser.username);
            redisClient.srem("users", testUser.username);
            t.end();
        });
    });
});

test("When an issue is created it's assigned to a user", function (t) {
    var testIssues = [testIssue1, testIssue2];

    DBHandlers.addUser(redisClient, testUser, function (errors, replies) {
        DBHandlers.addIssuesByUsername(redisClient, testUser.username, testIssues, function (errors, replies) {
            t.equal(errors, null);
            t.deepEqual(replies, ['OK', 1, 'OK', 1]);

            var multi = redisClient.multi();

            multi.del(testUser.username + ":issues");

            multi.del("issue:" + testIssues[0].id);
            multi.del("issue:" + testIssues[1].id);

            multi.del("user:" + testUser.username);
            multi.srem("users", testUser.username);

            multi.exec(function (err, replies) {
                t.end();
            })
        });
    });
});

test("Get issues by username", function (t) {
    var unsortedTestIssues= [testIssue1, testIssue2, testIssue3];

    DBHandlers.addUser(redisClient, testUser, function (errors, replies) {
        DBHandlers.addIssuesByUsername(redisClient, testUser.username, unsortedTestIssues, function (errors, replies) {
            DBHandlers.getIssuesByUsername(redisClient, testUser.username, function (errors, replies) {
                var sortedTestIssues = [testIssue3, testIssue1, testIssue2];
                t.deepEqual(replies, sortedTestIssues);

                var multi = redisClient.multi();

                multi.del(testUser.username + ":issues");

                multi.del("issue:" + sortedTestIssues[0].id);
                multi.del("issue:" + sortedTestIssues[1].id);
                multi.del("issue:" + sortedTestIssues[2].id);

                multi.del("user:" + testUser.username);
                multi.srem("users", testUser.username);

                multi.exec(function (err, replies) {
                    t.end();
                })
            });
        });
    });
});

test("Close clients after tests completed", function (t) {
    redisClient.end()
    t.end();
});
