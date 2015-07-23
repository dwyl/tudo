function addIssue (client, obj, callback) {
    var timeMS = Date.parse(obj.created_at);
    var multi  = client.multi();

    multi.hmset("issue:" + obj.id, obj);
    multi.zadd("issues", timeMS, obj.id);
    multi.exec(function (errors, replies) {
        return callback(errors, replies);
    });
}

function deleteIssueById (client, issueId, callback) {
    var multi = client.multi();

    multi.zrem("issues", issueId);
    multi.del("issue:" + issueId);
    multi.exec(function (errors, replies) {
        return callback(errors, replies);
    });
}

function addUser (client, obj, callback) {
    var multi  = client.multi();

    multi.hmset("user:" + obj.id, obj);
    multi.sadd("users", obj.id);
    multi.exec(function (errors, replies) {
        return callback(errors, replies);
    });
}

function deleteUserById (client, userId, callback) {
    var multi = client.multi();

    multi.srem("users", userId);
    multi.del("user:" + userId);
    multi.exec(function (errors, replies) {
        return callback(errors, replies);
    });
}

module.exports = {
    addIssue: addIssue,
    deleteIssueById: deleteIssueById,
    addUser: addUser,
    deleteUserById: deleteUserById
};
