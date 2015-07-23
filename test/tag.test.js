var riot = require('riot');
var test = require('tape');
var tag = require('../views');
var cheerio = require('cheerio');

test('Testing categories tag', function (t) {
  var mockHeader = {
    category: 'assigned'
  };

  var category = riot.render(tag.categories,mockHeader);
  var $ = cheerio.load(category);
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
});

test('Testing issue tag', function (t) {
  var mockIssue = {
    issue: {
      title: "Issue",
      org_repo: "Dwyl/tudo",
      first_line: "First line of the issue"
    }
  };
  var issue = riot.render(tag.issue,mockIssue);
  var $ = cheerio.load(issue);
  t.equal('Issue', $('h4').text(), 'title of issue tag works');
  t.equal('Dwyl/tudo', $('p').first().text(), 'org_repo of issue tag works');
  t.equal("First line of the issue", $('p').first().next().text(), 'first line of issue tag works');

  t.end();
});

test('Testing issues_list tag', function (t) {
  var mockIssues = {
    issues: [
      {
        title: "1",
        org_repo: "Dwyl/1",
        first_line: "First line of issue 1"
      },
      {
        title: "2",
        org_repo: "Dwyl/2",
        first_line: "First line of issue 2"
      },
      {
        title: "3",
        org_repo: "Dwyl/3",
        first_line: "First line of issue 3"
      }
     ]
  };

  var issueList = riot.render(tag.issueList, mockIssues);
  var $ = cheerio.load(issueList);
  t.equal(3, $('issue').length, 'issue list tag works');
  t.end();
});

test('Testing home_container tag', function (t) {
  var mock = {
    header: 'simon',
    category: 'assigned',
    issues: [
      {
        title: "1",
        org_repo: "Dwyl/1",
        first_line: "First line of issue 1"
      },
      {
        title: "2",
        org_repo: "Dwyl/2",
        first_line: "First line of issue 2"
      },
      {
        title: "3",
        org_repo: "Dwyl/3",
        first_line: "First line of issue 3"
      }
     ]
  };

  var container = riot.render(tag.homeContainer, mock);
  var $ = cheerio.load(container);
  t.equal(1, $('nav').length, 'nav tag works in homeContainer ');
  t.equal(1, $('categories').length, 'categories tag works in homeContainer');
  t.equal(1, $('issue-list').length, 'issue-list tag works in homeContainer');
  t.equal(3, $('issue').length, 'issue tag works in homeContainer');
  t.end();
});
