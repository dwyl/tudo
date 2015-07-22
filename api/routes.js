var riot    = require('riot');
var Path    = require('path');
var auth_handler = require('./handlers/github_auth');
console.log(auth_handler)

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
        path:'/issues', 
        handler: require("./handlers/get-issues.js")
    },
    {
        method: 'GET',
        path:'/labels',
        handler: require("./handlers/LabelsCtrl.js").get
    },
    {
        method: 'POST',
        path:'/labels',
        handler: require("./handlers/LabelsCtrl.js").create
    },
    {
        method: 'PUT',
        path:'/labels',
        handler: require("./handlers/LabelsCtrl.js").update
    },
    {
        method: 'DELETE',
        path:'/labels/{name}',
        handler: require("./handlers/LabelsCtrl.js").remove
    },
    {
        method: 'GET',
        path:'/login', 
        handler: auth_handler
    }
];

module.exports = routes;
