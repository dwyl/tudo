var riot    = require('riot');
var Path    = require('path');
var auth_handler = require('./handlers/github_auth');

var routes = [
    {
        method: 'GET',
        path: '/{param*}',
        handler: {
            directory: {
                path: Path.normalize(__dirname + '/')
            }
        }
    },
    {
        method: 'GET',
        path:'/issues/{filter*}', 
        handler: require("./handlers/get-issues.js")
    },
    {
        method: 'GET',
        path:'/login',
        handler: auth_handler
    }
];

module.exports = routes;
