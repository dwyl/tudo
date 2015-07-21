require('./lib/env'); // initialise environment variables
var Hapi = require('hapi');
var Path = require('path');
var server = new Hapi.Server();

server.connection({
	host: '0.0.0.0',
	port: Number(process.env.PORT)
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

server.route([
	{ method: 'GET', path: '/login',          handler: auth_handler },
  { method: 'GET', path: '/hello/{name*}',  handler: hello_handler },
	{ method: 'GET', path: '/',               handler: auth_handler },
  { method: 'GET', path: '/{param*}', handler: { directory: { path: Path.normalize(__dirname + '/') } } }
]);

server.start(function () {
	// require('./lib/chat').init(server.listener, function(){
	// 	console.log(process.env.REDISCLOUD_URL);
		console.log('Got issues...?', 'listening on: http://127.0.0.1:'+process.env.PORT);
	// });
});

module.exports = server;
