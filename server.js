require('./lib/env.js')
var Hapi = require('hapi');
var server = new Hapi.Server();

server.register(require('inert'), function(){
	server.connection({
		host: '0.0.0.0',
		port: Number(process.env.PORT)
	});

	server.route(require('./api/routes.js'));

	server.start(function () {
		console.log('Got issues...? ' + server.info.uri);
	});
})


module.exports = server;
