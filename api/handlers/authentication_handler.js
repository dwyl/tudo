var riot = require('riot');
var views = require('../../views');

function authentication_handler (request, reply) {
	// if the credentials are set don't force people to re-login!
	// if(request.auth.credentials) {
	// 	console.log(' - - - - - - - - - - - - - - - - - - - -')
	// 	console.log(request.auth.credentials)
	// 	console.log(' - - - - - - - - - - - - - - - - - - - -')
	// }
	var body = riot.render(views.login, {GITHUB_CLIENT_ID : process.env.GITHUB_CLIENT_ID })
	reply(views.header + body + views.footer);
}

module.exports = authentication_handler;