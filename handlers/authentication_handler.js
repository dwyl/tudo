var riot = require('riot');
var views = require('../views');

module.exports = function authentication_handler (request, reply) {
	var body = riot.render(views.login);
	reply(views.header + body + views.footer);
}
