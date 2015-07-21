var Hapi = require('hapi');
var server = new Hapi.Server();


server.connection({
	host: '0.0.0.0',
	port: Number(process.env.PORT || 8000)
});

var riot = require('riot');
var views = require('./views');

function hello_handler (request, reply) {
	var html = riot.render(views.hello, {name: request.params.name})
	return reply(html);
}

function auth_handler (request, reply) {
	// if the credentials are set don't force people to re-login!
	// if(request.auth.credentials) {
	// 	console.log(' - - - - - - - - - - - - - - - - - - - -')
	// 	console.log(request.auth.credentials)
	// 	console.log(' - - - - - - - - - - - - - - - - - - - -')
	// }
	var body = riot.render(views.login, {GITHUB_CLIENT_ID : process.env.GITHUB_CLIENT_ID })
	reply(views.header + body + views.footer);
}

server.route(require('./api/routes.js'));

server.start(function () {
	console.log('Have you got issues...?' + server.info.uri);
});

module.exports = server;
