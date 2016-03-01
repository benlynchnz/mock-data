Mock = require '../models/mock'

module.exports = (app) ->

	app.post "/", (next) ->

		body = @request.body
		user = yield Credentials.createCredentials(body)
			.then (res) ->
				return res

		if user
			@status = 201
			@body = user
		else
			@status = 500

	app.get "/drivers.json", (next) ->

		count = @request.query.count or 100

		result = yield Mock.getDrivers(count)
			.then (res) ->
				return res

		@set 'X-Total-Count', result.length

		if result
			@status = 200
			@body =
				Items: result
		else
			@status = 404

	app.get "/reports", (next) ->

		rows_per_page = @request.query['per_page'] or 10
		page = @request.query['page'] or 0

		result = yield Mock.getReports(page, rows_per_page)
			.then (res) ->
				return res

		@set 'X-Total-Count', 819

		if result
			@status = 200
			@body = result
		else
			@status = 404
