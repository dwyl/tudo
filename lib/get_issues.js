"use strict";

var Wreck = require('wreck');


function getIssues (filter, cb) {

    var url = "https://api.github.com/issues?filter=" + filter;

    var options = {
        json: true,
        headers: {
            'Authorization': 'token ' + process.env.GITHUB_KEY,
            'User-Agent': ""
        }
    }

    Wreck.get(url, options, function (err, res, issues) {

        if (issues.hasOwnProperty('errors')) {
            return cb(issues); // returns an object containing error details for later error handling
        }

        var store = [];

        issues.forEach(function (elm, i) {

            var commentsUrl = elm.comments_url;

            Wreck.get(commentsUrl, options, function (errComments, response, comments) {

                issues[i].comment_items = comments;
                store.push(issues[i]);

                if (store.length === issues.length) {

                    return cb(null, store);
                }
            });
        });
    });
}

module.exports = getIssues;
