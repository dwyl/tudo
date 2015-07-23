var riot = require('riot');
var test = require('tape');
var tag = require('../views');
var cheerio = require('cheerio');

test('Testing categories tag', function (t) {
  var mockHeader = {
    category: 'assigned'
  };

  var cattegory = riot.render(tag.categories,mockHeader);
  var $ = cheerio.load(cattegory);
  t.equal('assigned', $('h2').text(), 'category tag works');

  t.end();

});

test('Testing nav tag', function (t) {
  var mockHeader = {
    header: 'simon'
  };
  var nav = riot.render(tag.nav,mockHeader);
  var $ = cheerio.load(nav);
  t.equal('simon', $('h1').text(), 'nav tag works');

  t.end();
})
