var fs = require('fs');

module.exports = {
  hello  : require(__dirname +'/hello.tag'),
  header : fs.readFileSync(__dirname +'/layout_header.html', 'utf8'),
  footer : fs.readFileSync(__dirname +'/layout_footer.html', 'utf8'),
  login  : require(__dirname +'/login.tag')
}
