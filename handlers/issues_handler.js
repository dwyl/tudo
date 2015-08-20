var riot = require('riot');
var tags = require('../views/');

exports.handler = function (req, reply) {
  reply(tags.prefix + riot.render(tags.issues_page, {prioritised_issues: require("../test/fixtures/issues.json")}) + tags.suffix);
}

exports.parse = function (entries) {

  return [{issues: true, priority: true}, {issues: true, priority: true}, {issues: true, priority: true}]
}
