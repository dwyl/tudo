var Hapi    = require('hapi');
var server  = new Hapi.Server();


var serverOptions = {
    port: process.env.PORT || 8000,
};

server.connection(serverOptions);

server.route(require('./routes.js'));

server.start(function(){
    console.log('server running: '+server.info.uri);
});

module.exports = server;
