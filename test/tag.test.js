var riot = require('riot');
var test = require('tape');
var tag = require('../views');
var cheerio = require('cheerio');
var db_fixtures = require('./fixtures/db_handlers_fixtures.js');
var home_fixtures = require('./fixtures/home_page_fixtures.js');
var gh_fixtures = require('./fixtures/gh_to_db_parser_fixtures.js');


test('Testing categories tag', function (t) {

  var category = riot.render(tag.categories,home_fixtures);
  var $ = cheerio.load(category);
  t.equal('assigned', $('h2').text(), 'category tag works');

  t.end();

});

test('Testing nav tag', function (t) {

  var nav = riot.render(tag.nav,gh_fixtures.parsedIssue1);
  var $ = cheerio.load(nav);
  t.equal('jrans', $('h1').text(), 'nav tag works');

  t.end();
});

test('Testing issue tag', function (t) {
  var issue = riot.render(tag.issue,gh_fixtures.parsedIssue1);
  var $ = cheerio.load(issue);
  t.equal('example issue JSON format', $('h4').text(), 'title of issue tag works');
  t.equal('tudo', $('p').first().text(), 'org_repo of issue tag works');
  t.equal("when adding example files to repos always format them so they are as readable as possible (_for the next person_).  ", $('p').first().next().text(), 'first line of issue tag works');

  t.end();
});

test('Testing issues_list tag', function (t) {

  var issueList = riot.render(tag.issueList, {issues: home_fixtures.parsedIssueArray} );
  var $ = cheerio.load(issueList);
  t.equal(2, $('issue').length, 'issue list tag works');
  t.end();
});

test('Testing home_container tag', function (t) {
  var mock = {
    header: 'simon',
    category: 'assigned',
    issues:  home_fixtures.parsedIssueArray
  };

  var container = riot.render(tag.homeContainer, mock);
  var $ = cheerio.load(container);
  t.equal(1, $('nav').length, 'nav tag works in homeContainer ');
  t.equal(1, $('categories').length, 'categories tag works in homeContainer');
  t.equal(1, $('issue-list').length, 'issue-list tag works in homeContainer');
  t.equal(2, $('issue').length, 'issue tag works in homeContainer');
  t.end();
});
