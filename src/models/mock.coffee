Reports = require './data/reports'
Drivers = require './data/drivers'

Mock = ->

Mock.getReports = (page, rows) ->
	new Promise (resolve, reject) ->
		Reports.get page, rows, (err, result) ->
			if err then reject(err)
			else resolve(result)

Mock.getDrivers = (count) ->
	new Promise (resolve, reject) ->
		Drivers.get count, (err, result) ->
			if err then reject(err)
			else resolve(result)

module.exports = Mock
