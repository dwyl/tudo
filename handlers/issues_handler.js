var riot = require('riot');
var tags = require('../views/');

exports.handler = function (req, reply) {
  reply(tags.prefix + riot.render(tags.issues_page, {prioritised_issues: require("../test/fixtures/issues.json")}) + tags.suffix);
}

exports.parse = function (entries) {
  if (typeof entries === 'string') {
    entries = JSON.parse(entries);
  }
  return [{issues: [], priority: NaN}, {issues: [], priority: NaN}, {issues: [], priority: NaN}]
}
