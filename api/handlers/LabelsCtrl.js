'use strict';

/**
 *	LablesCtrl
 *
 *	Create custom labels and add lables to existing issues.
 *
 *	CRUD operations --> https://developer.github.com/v3/issues/labels/#create-a-label
 *
 *				POST   /repos/:owner/:repo/labels
 *				GET    /repos/:owner/:repo/labels
 *				PATCH  /repos/:owner/:repo/labels/:name
*				DELETE /repos/:owner/:repo/labels/:name
 *
 *
 *	#addToIssue --> https://developer.github.com/v3/issues/labels/#add-labels-to-an-issue
 *
 *				POST   /repos/:owner/:repo/issues/:number/labels
 *				DELETE /repos/:owner/:repo/issues/:number/labels/:name
 */

var wreck = require('wreck');
var Joi   = require('joi');

/**
 *	Get authorization headers
 *
 */
function getHeaders () {

	return {
		'Authorization': 'token ' + process.env.GITHUB_KEY ,
		'User-Agent': "" //makes no sense at all
	}
}

/**
 *	Create request object for creating a label.
 *
 *	@param  {Object} - new label attributes i.e. {name: 'string', color: 'string'}
 *	@return {String} - stringify json object
 *
 */
function lableLink (lableObj) {

	return JSON.stringify({
		name:  lableObj.name,
		color: lableObj.color
	})
}

module.exports = {

	get: function (request, reply) {

		var opts = {
			headers: getHeaders()
		};

		wreck.request(
			'GET',
			'https://api.github.com/repos/dwyl/tudo/labels',
			opts,
			function (err, response, payload) {

				wreck.read(response, null, function (errRead, bodyRead) {

					// console.log(JSON.parse(bodyRead.toString()));

					return reply(JSON.parse(bodyRead.toString()));
				});
			}
		);
	},
	create: function (request, reply) {

		var schemaLabel = Joi.object().keys({
			name:  Joi.string().required(),
			color: Joi.string().required()
		});

		var resultValidation = Joi.validate(request.payload, schemaLabel);

		if (resultValidation.error) {
			return reply({error: resultValidation.error}).code(400);
		}

		var opts = {
			headers: getHeaders(),
			payload: lableLink(request.payload)
		};

		wreck.request(
			'POST',
			'https://api.github.com/repos/dwyl/tudo/labels',
			opts, 
			function (err, response) {

				wreck.read(response, null, function (errRead, bodyRead) {

					// console.log(JSON.parse(bodyRead.toString()));

					return reply(JSON.parse(bodyRead.toString()));
				});
			}
		);
	},
	update: function (request, reply) {

		var schemaLabel = Joi.object().keys({
			oldName: Joi.string().required(),
			name:    Joi.string().required(),
			color:   Joi.string().required()
		});

		var resultValidation = Joi.validate(request.payload, schemaLabel);

		if (resultValidation.error) {

			return reply({error: resultValidation.error}).code(400);
		}

		var opts = {
			headers: getHeaders(),
			payload: lableLink(request.payload)
		};

		wreck.request(
			'PATCH',
			'https://api.github.com/repos/dwyl/tudo/labels/' + request.payload.oldName,
			opts,
			function (err, response, payload) {

				wreck.read(response, null, function (errRead, bodyRead) {

					// console.log(JSON.parse(bodyRead.toString()));

					return reply(JSON.parse(bodyRead.toString()));
				});
			}
		);
	},
	remove: function (request, reply) {

		var opts = {
			headers: getHeaders()
		};

		wreck.request(
			'DELETE',
			'https://api.github.com/repos/dwyl/tudo/labels/' + request.params.name,
			opts,
			function (err, response) {

				wreck.read(response, null, function (errRead, bodyRead) {

					// console.log(JSON.parse(bodyRead.toString()));

					return reply(response);
				});
			}
		);
	}
};
