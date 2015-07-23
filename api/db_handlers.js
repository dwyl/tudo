

function addUser (client, obj, callback) {
    var multi  = client.multi();

    multi.hmset("user:" + obj.username, obj);
    multi.sadd("users", obj.username);
    multi.exec(function (errors, replies) {
        return callback(errors, replies);
    });
}

function getUserByUsername (client, username, callback) {
    client.hgetall("user:" + username, callback);
}

function addIssue (client, obj, callback) {
    client.hmset("issue:" + obj.id, obj, callback);
}

function addIssueToUserList (client, username, issueId, lastUpdateTime, callback) {
    var timeMS = Date.parse(lastUpdateTime);

    client.zadd(username + ":issues", timeMS, issueId, callback);
}

function addIssuesByUsername (client, username, issuesArray, callback) {
    var multi  = client.multi();

    issuesArray.forEach(function (issue) {
        addIssue(multi, issue);
        addIssueToUserList(multi, username, issue.id, issue.updated_at);
    });
    multi.exec(function (errors, replies) {
        return callback(errors, replies);
    });
}

function getIssueListByUsername (client, username, callback) {
    client.zrange(username + ":issues",0,-1, callback); //err, data
}

function getIssuesByList (client, issueList, callback) {
    var multi = client.multi();
    issueList.forEach(function (issueId) {
      multi.hgetall("issue:" + issueId)
    });
    multi.exec(function (err, replies) {
      return callback(err, replies);
    });
}

function getIssuesByUsername (client, username, callback) {
    getIssueListByUsername(client, username, function(err, data) {
        getIssuesByList (client, data, callback);
    })
}


module.exports = {
    addUser: addUser,
    getUserByUsername: getUserByUsername,
    addIssuesByUsername: addIssuesByUsername,
    getIssuesByUsername: getIssuesByUsername
};
