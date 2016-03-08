Reports = require './data/reports'
Drivers = require './data/drivers'
levelup = require 'levelup'
Guid    = require 'guid'
_       = require 'lodash'
moment  = require 'moment'

driverDB = levelup('./driverDB', {
	valueEncoding: 'json'
})

Mock = ->

Mock.getReports = (page, rows) ->
	new Promise (resolve, reject) ->
		Reports.get page, rows, (err, result) ->
			if err then reject(err)
			else resolve(result)

Mock.getDrivers = (count) ->
	results = []
	new Promise (resolve, reject) ->
		driverDB.createReadStream()
			.on "data", (data) ->
				result =
					id: data.key
				_.merge(result, data.value)
				results.push result
			.on "error", (err) ->
				reject(err)
			.on "end", () ->
				resolve(results)

Mock.createDriver = (driver) ->
	id = Guid.create().value
	driver.created_at = moment()
	driver.updated_at = moment()
	new Promise (resolve, reject) ->
		driverDB.put id, driver, (err) ->
			if err then reject(err)
			driverDB.get id, (err, result) ->
				if err then reject(err)
				else
					result.id = id
					resolve(result)

Mock.updateDriver = (id, driver) ->
	new Promise (resolve, reject) ->
		driverDB.get id, (err, result) ->
			if err then reject(err)
			driverDB.put id, driver, (err) ->
				if err then reject(err)
				driverDB.get id, (err, update) ->
					if err then reject(err)
					else resolve(update)

module.exports = Mock
