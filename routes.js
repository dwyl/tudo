var riot    = require('riot');
var Path    = require('path');

var routes = [
  {
      method: 'GET',
      path: '/',
      handler: function(req, reply){
        var tags = require('./views/');
        reply(tags.header + riot.render(tags.login, {GITHUB_CLIENT_ID:process.env.GITHUB_CLIENT_ID}) + tags.footer)
      }
  },
  {
    method: 'GET',
    path: '/{param*}',
    handler: {
      directory: {
        path: Path.normalize(__dirname + '/')
      }
    }
  },
  {
    method: 'GET',
    path:'/labels',
    handler: require("./handlers/labels_handler.js").get
  },
  {
    method: 'POST',
    path:'/labels',
    handler: require("./handlers/labels_handler.js").create
  },
  {
    method: 'PUT',
    path:'/labels',
    handler: require("./handlers/labels_handler.js").update
  },
  {
    method: 'DELETE',
    path:'/labels/{name}',
    handler: require("./handlers/labels_handler.js").remove
  },
  {
    method: 'GET',
    path:'/login',
    handler: require('./handlers/authentication_handler.js')
  }
];

module.exports = routes;
