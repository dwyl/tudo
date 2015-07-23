var riot = require('riot');
var views = require('../../views');

function auth_handler (request, reply) {
	var body = riot.render(views.login);
	reply(views.header + body + views.footer);
}

module.exports = auth_handler;
