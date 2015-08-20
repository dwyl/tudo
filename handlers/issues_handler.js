var riot = require('riot');
var tags = require('../views/');

module.exports = function (req, reply) {
	reply(tags.prefix + riot.render(tags.issues_page, {prioritised_issues: require("../test/fixtures/issues.json")}) + tags.suffix);
}
