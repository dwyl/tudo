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
    multi.del("issue:"+issueId);
    multi.exec(function (errors, replies) {
        return callback(errors, replies);
    });
}

module.exports = {
    addIssue: addIssue,
    deleteIssueById: deleteIssueById
};
