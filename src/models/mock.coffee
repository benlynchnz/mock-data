Reports = require './data/reports'

Mock = ->

Mock.getReports = (page, rows) ->
	new Promise (resolve, reject) ->
		Reports.get page, rows, (err, result) ->
			if err then reject(err)
			else resolve(result)

module.exports = Mock
