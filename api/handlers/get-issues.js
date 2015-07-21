var config = require("../../config.json");

var getIssues = {

    proxy: {

        mapUri: function (request, callback) {
            var url = "https://api.github.com/issues";
            var headers = {
                'Authorization': 'token ' + config.GHAPIKEY,
                'User-Agent': request.params.username
            }

            callback(null, url, headers);
        },
    }
}

module.exports = getIssues;