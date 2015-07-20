module.exports = [
    {
        method: 'GET',
        path:'/issues/{username}',
        handler: {
            proxy: {
                mapUri: function (request,callback){
                    var url = "https://api.github.com/issues";
                    console.log(url);
                    callback(null, url, {
                        'Authorization': 'token ' +require("./config.json").GHAPIKEY,
                        'User-Agent': request.params.username
                    });
                },
            }
        }
    }
];
