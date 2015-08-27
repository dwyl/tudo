// var DB        = require("./db_handlers.js");
// var parser    = require("./parse_issues.js");
// var getIssues = require("./get_issues");
//
// module.exports = function (client, username, callback) { // only username that cna be used is dwyl dummy
//     DB.checkUserExists(client, username, function (err, reply) {
//         if (reply===1) {
//             DB.getIssuesByUsername(client, username, callback);
//         } else {
//             DB.addUser(client, {username:username}, function (err, reply) {
//                 getIssues("assigned", function (err, data) {
//                     var parsed = parser(data);
//                     DB.addIssuesByUsername(client, username, parsed, function (err, replies) {
//                         callback(err, parsed);
//                     });
//                 });
//             });
//         }
//     });
// }

// >>>> This is all going to be re-factored!
