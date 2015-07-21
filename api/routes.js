var riot    = require('riot');
var Path    = require('path');

// Temp code
function hello_handler (request, reply) {
    var views   = require('../views');
    var html = riot.render(views.hello, {name: request.params.name})

    return reply(html);
}

var routes = [
    {
        method: 'GET',
        path: '/hello/{name*}',
        handler: hello_handler
    },
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
    }
];

module.exports = routes;
