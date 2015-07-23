var fs = require('fs');

module.exports = {
  header : fs.readFileSync(__dirname +'/layout_header.html', 'utf8'),
  footer : fs.readFileSync(__dirname +'/layout_footer.html', 'utf8'),
  login  : require(__dirname +'/tags/login.tag'),
  categories  : require(__dirname +'/tags/home/categories.tag'),
  nav  : require(__dirname +'/tags/home/nav.tag'),
  issue  : require(__dirname +'/tags/home/issue.tag'),
  issueList  : require(__dirname +'/tags/home/issues_list.tag'),
  homeContainer  : require(__dirname +'/tags/home/container_home.tag')
}
