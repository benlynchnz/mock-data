nconf      = require 'nconf'
router     = require 'koa-router'
bodyParser = require 'koa-bodyparser'
cors       = require 'koa-cors'
app        = require('koa')()

nconf.argv().env()

app.port = nconf.get('PORT') or 3000
app.env = nconf.get('NODE_ENV') or 'development'
app.origin = 'http://localhost:3010'
app.nconf = nconf
app.cwd = __dirname
app.package = require '../package.json'

app.use(
	cors({
		origin: app.origin
		expose: ['X-Total-Count']
	})
)

app.use (next) ->
	start = new Date
	yield next
	ms = new Date - start
	console.log '%s %s - %s', @method, @url, ms

app.use (next) ->
	@set 'X-Service', "#{app.package.name}/#{app.package.version}"
	yield next

app.use (next) ->
	try
		yield next
	catch err
		@status = 500
		@body = err.message
		@app.emit 'error', err, @


app.on 'error', (err, ctx) ->
	console.log new Date().toISOString()
	console.log err.stack if err
	console.log ctx

app.use(bodyParser())
app.use(router(app))

app.get "/ping", (next) ->
	@status = 200
	yield next

## ROUTES
require('./routes/mock')(app)

app.listen(app.port)
console.log "############ || STARTING -> #{new Date().toISOString()} || #####################"
console.log "| LISTENING on PORT -> #{app.port} | NODE_ENV -> #{app.env} | SERVICE -> #{app.package.name}/#{app.package.version}"
console.log "################################################################################"
