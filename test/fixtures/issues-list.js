var gs = require('github-scraper');
var fs = require('fs');

var tudo_issues_URL = 'https://github.com/dwyl/tudo/issues'
gs(tudo_issues_URL, function (err, data) {
	var filePath = __dirname + '/issues.json';
	console.log(filePath);
	fs.writeFileSync(filePath, JSON.stringify(data));
});
