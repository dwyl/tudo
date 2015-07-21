var config = require("../../env.json");

var getIssues = {

    proxy: {

        mapUri: function (request, callback) {
            var url = "https://api.github.com/issues";
            // both the header values are temporary until we have github auth
            var headers = {
                'Authorization': 'token ' + config.GHAPIKEY,
                'User-Agent': "" //makes no sense at all
            }

            callback(null, url, headers);
        },
    }
}

module.exports = getIssues;
