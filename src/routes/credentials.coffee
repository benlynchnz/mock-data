Credentials = require '../models/credentials'
crypto      = require 'crypto'

decrypt = (text) ->
	decipher = crypto.createDecipher('aes-256-cbc','123456')
	dec = decipher.update(text,'hex','utf8')
	dec += decipher.final('utf8')
	return dec

module.exports = (app) ->

	# Create new credentials
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

	# Get credentials
	app.get "/:id", (next) ->

		user = yield Credentials.getActiveCredentials(@params.id)
			.then (res) ->
				return res

		if user
			result = user.get()
			result.password = decrypt(user.get('password'))
			@status = 200
			@body = result
		else
			@status = 404

	# Get credentials for user & supplier
	app.get "/users/:user", (next) ->

		credentials = yield Credentials.getCredentialsByUser(@params.user, @request.query.supplier)
			.then (res) ->
				return res
				
		if credentials
			# result = credentials.get()
			# result.password = decrypt(credentials.get('password'))
			# @status = 200
			@body = credentials
		else
			@status = 404
