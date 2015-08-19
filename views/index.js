var fs = require('fs');

module.exports = {
  prefix : fs.readFileSync(__dirname +'/prefix.html', 'utf8'),
  suffix : fs.readFileSync(__dirname +'/suffix.html', 'utf8'),
  login  : require(__dirname +'/tags/login.tag'),
  nav  : require(__dirname +'/tags/home/nav.tag'),
  issue  : require(__dirname +'/tags/home/issue.tag'),
  issues: require(__dirname + '/tags/home/issues.tag'),
  issues_page: require(__dirname + '/tags/home/issues_page.tag')
}
