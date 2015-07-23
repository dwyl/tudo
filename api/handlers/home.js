var riot = require('riot');
var views = require('../../views');

function home (request, reply) {
	var body = riot.render(views.homeContainer,{
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
  } );

	reply(views.header + body + views.footer);
}

module.exports = home;
