require('../lib/env.js');
var test        = require("tape");
var url         = require('url');
var redisConfig = require("../lib/redis_config");
var DBHandlers  = require("../api/db_handlers.js");
var connection  = url.parse(process.env.TEST_REDISCLOUD_URL);

test("Adding an issue to DB", function (t) {
    var redisClient = redisConfig(connection);
    var testIssue = {
        id: 12345678,
        created_at: "2015-06-22T09:22:51Z",
    };
    DBHandlers.addIssue(redisClient, testIssue, function (errors, replies) {
        t.equal(errors, null, "add errors null");
        t.deepEqual(replies, ["OK",1], "should get an OK from setting hash, and 1 for addition to set of issues");
        DBHandlers.deleteIssueById(redisClient, testIssue.id, function (errors, replies) {
            redisClient.end()
            t.end();
        });
    });
});

test("Deleting an issue by id", function (t) {
    var redisClient = redisConfig(connection);
    var testIssue = {
        id: 23456789,
        created_at: "2015-06-22T09:22:51Z",
    };

    DBHandlers.addIssue(redisClient, testIssue, function (errors, replies) {
        DBHandlers.deleteIssueById(redisClient, testIssue.id, function (errors, replies) {
            t.equal(errors, null, "delete errors null");
            t.deepEqual(replies, [1,1], "1 deleted from set of issues and database respectively");
            redisClient.end()
            t.end();
        });
    });
});

test("Adding a user to DB", function (t) {
    var redisClient = redisConfig(connection);
    var testUser = {
        id: 12345678,
    };
    DBHandlers.addUser(redisClient, testUser, function (errors, replies) {
        t.equal(errors, null, "add errors null");
        t.deepEqual(replies, ["OK",1], "should get an OK from setting hash, and 1 for addition to set of users");
        DBHandlers.deleteUserById(redisClient, testUser.id, function (errors, replies) {
            redisClient.end()
            t.end();
        });
    });
});

test("Deleting a user by id", function (t) {
    var redisClient = redisConfig(connection);
    var testUser = {
        id: 23456789,
    };

    DBHandlers.addUser(redisClient, testUser, function (errors, replies) {
        DBHandlers.deleteUserById(redisClient, testUser.id, function (errors, replies) {
            t.equal(errors, null, "delete errors null");
            t.deepEqual(replies, [1,1], "1 deleted from set of users and database respectively");
            redisClient.end()
            t.end();
        });
    });
});
