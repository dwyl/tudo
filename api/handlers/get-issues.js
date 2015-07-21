var getIssues = {

    proxy: {

        mapUri: function (request, callback) {
            var url = "https://api.github.com/issues";
            // both the header values are temporary until we have github auth
            var headers = {
                'Authorization': 'token ' + process.env.GITHUB_KEY ,
                'User-Agent': "" //makes no sense at all
            }

            callback(null, url, headers);
        },
    }
}
console.log(process.env.GITHUB_KEY)

module.exports = getIssues;
