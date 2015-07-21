var fs = require('fs');
var envfile = '../env.json';
if(fs.statSync(envfile)) { // only attempt to load the file if it exists!
  var env = require('../env.json');
  var keys = Object.keys(env);
  keys.map(function(k) {
    if(!process.env[k]) { // allow enviroment to take precedence over env.json
      process.env[k] = env[k]; // only set if not set by environment
    }
  }); // for a better way of doing this see: https://github.com/dshaw/env/pull/8

}
