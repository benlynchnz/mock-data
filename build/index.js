(function() {
  var app, bodyParser, cors, nconf, router;

  nconf = require('nconf');

  router = require('koa-router');

  bodyParser = require('koa-bodyparser');

  cors = require('koa-cors');

  app = require('koa')();

  nconf.argv().env();

  app.port = nconf.get('PORT') || 3000;

  app.env = nconf.get('NODE_ENV') || 'development';

  app.origin = 'http://localhost:3010';

  app.nconf = nconf;

  app.cwd = __dirname;

  app["package"] = require('../package.json');

  app.use(cors({
    origin: app.origin,
    expose: ['X-Total-Count']
  }));

  app.use(function*(next) {
    var ms, start;
    start = new Date;
    (yield next);
    ms = new Date - start;
    return console.log('%s %s - %s', this.method, this.url, ms);
  });

  app.use(function*(next) {
    this.set('X-Service', app["package"].name + "/" + app["package"].version);
    return (yield next);
  });

  app.use(function*(next) {
    var err;
    try {
      return (yield next);
    } catch (_error) {
      err = _error;
      this.status = 500;
      this.body = err.message;
      return this.app.emit('error', err, this);
    }
  });

  app.on('error', function(err, ctx) {
    console.log(new Date().toISOString());
    if (err) {
      console.log(err.stack);
    }
    return console.log(ctx);
  });

  app.use(bodyParser());

  app.use(router(app));

  app.get("/ping", function*(next) {
    this.status = 200;
    return (yield next);
  });

  require('./routes/mock')(app);

  app.listen(app.port);

  console.log("############ || STARTING -> " + (new Date().toISOString()) + " || #####################");

  console.log("| LISTENING on PORT -> " + app.port + " | NODE_ENV -> " + app.env + " | SERVICE -> " + app["package"].name + "/" + app["package"].version);

  console.log("################################################################################");

}).call(this);
