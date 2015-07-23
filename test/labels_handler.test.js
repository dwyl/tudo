'use strict';

var test   = require('tape');
var server = require('../server');

test('Labels controller', function (t) {

	t.test('#get all labels', function (st) {

		st.plan(2);

		server.inject({
			method: 'GET', 
			url:    '/labels'
		}, function (res) {

			st.equals(Object.prototype.toString.call(res.payload), '[object String]', 'payload is a string');
			st.equals(Object.prototype.toString.call(JSON.parse(res.payload)), '[object Array]', 'payload content is an array');
		});
	});

	t.test('#create one label WITHOUT right data attributes', function (st) {

		st.plan(1);

		server.inject({
			method: 'POST', 
			url:    '/labels',
			payload: {
				name: 'Bes'
			}
		}, function (res) {

			st.equals(res.statusCode, 400, 'correct status code');
		});
	});

	t.test('#create one label', function (st) {

		st.plan(2);

		server.inject({
			method: 'POST', 
			url:    '/labels',
			payload: {
				name: 'Bes',
				color: 'f29513'
			}
		}, function (res) {

			st.equals(JSON.parse(res.payload).name,  'Bes',    'right name');
			st.equals(JSON.parse(res.payload).color, 'f29513', 'right color');
		});
	});

	t.test('#update one label WITHOUT right attributes params', function (st) {

		st.plan(1);

		server.inject({
			method: 'PUT', 
			url:    '/labels',
			payload: {
				name: 'Cool',
				color: 'f29513'
			}
		}, function (res) {

			st.equals(res.statusCode, 400, 'correct status code');
		});
	});

	t.test('#update one label', function (st) {

		st.plan(2);

		server.inject({
			method: 'PUT', 
			url:    '/labels',
			payload: {
				oldName: 'Bes',
				name: 'Cool',
				color: 'f29513'
			}
		}, function (res) {

			st.equals(JSON.parse(res.payload).name,  'Cool',   'right name');
			st.equals(JSON.parse(res.payload).color, 'f29513', 'right color');
		});
	});

	t.test('#delete one label', function (st) {

		st.plan(1);

		server.inject({
			method: 'DELETE', 
			url:    '/labels/Cool',
		}, function (res) {

			st.equals(res.headers.status, '204 No Content', 'right status headers');
		});
	});
});
