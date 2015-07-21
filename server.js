require('./lib/env.js')
var Hapi = require('hapi');
var server = new Hapi.Server();


server.connection({
	host: '0.0.0.0',
	port: Number(process.env.PORT)
});

server.route(require('./api/routes.js'));

server.start(function () {
	console.log('Have you got issues...?' + server.info.uri);
});

module.exports = server;
