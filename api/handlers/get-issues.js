var Wreck = require('wreck');
var Boom = require('boom');

function getIssues (request, reply) {

    var filter = request.params.filter;
    var url = "https://api.github.com/issues?filter=" + filter;
    var options = {
        json: true,
        headers: {
            'Authorization': 'token ' + process.env.GITHUB_KEY,
            'User-Agent': ""
        }
    }

    Wreck.get(url, options, function (err, res, payload) {

        if (err || payload.hasOwnProperty('errors')) {
            return reply(Boom.badRequest("Sorry, that option does not exist."));
        }

        reply(payload);
    });
}

module.exports = getIssues;
