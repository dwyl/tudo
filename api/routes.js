var riot    = require('riot');


var routes = [
    {
        method: 'GET',
        path: '/{param*}',
        handler: {
            directory: {
                path: './public'
            }
        }
    },

    {
        method: 'GET',
        path:'/labels',
        handler: require("./handlers/labels_handler.js").get
    },
    {
        method: 'POST',
        path:'/labels',
        handler: require("./handlers/labels_handler.js").create
    },
    {
        method: 'PUT',
        path:'/labels',
        handler: require("./handlers/labels_handler.js").update
    },
    {
        method: 'DELETE',
        path:'/labels/{name}',
        handler: require("./handlers/labels_handler.js").remove
    },
    {
        method: 'GET',
        path:'/login',
        handler: require('./handlers/authentication_handler.js')
    }
];

module.exports = routes;
