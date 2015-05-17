AWS    = require 'aws-sdk'
vogels = require 'vogels'
Joi    = require 'joi'
_      = require 'lodash'
crypto = require 'crypto'

db = new AWS.DynamoDB()
vogels.dynamoDriver(db)

encrypt = (password) ->
	cipher = crypto.createCipher('aes-256-cbc', '123456')
	crypted = cipher.update(password, 'utf8', 'hex')
	crypted += cipher.final('hex')
	return crypted

Credentials = vogels.define('credential',
	hashKey: '_id'
	timestamps: true
	createdAt: 'created_at'
	updatedAt: 'updated_at'
	schema:
		_id: vogels.types.uuid()
		user: Joi.string().guid()
		username: Joi.string()
		status: Joi.string()
		password: Joi.string()
		supplier: Joi.string()
	)

Credentials.createCredentials = (json) ->
	new Promise (resolve, reject) ->
		json.password = encrypt(json.password)
		Credentials.create json
		, (err, result) ->
			if err then reject(err)
			else resolve(result)

Credentials.getActiveCredentials = (_id) ->
	new Promise (resolve, reject) ->
		Credentials.get _id, (err, result) ->
			if err then reject(err)
			else resolve(result)

vogels.createTables (err) ->
	console.log err if err	

module.exports = Credentials
