(function() {
  var app, bodyParser, nconf, router;

  nconf = require('nconf');

  router = require('koa-router');

  bodyParser = require('koa-bodyparser');

  app = require('koa')();

  nconf.argv().env();

  app.port = nconf.get('PORT') || 3000;

  app.env = nconf.get('NODE_ENV') || 'development';

  app.nconf = nconf;

  app.cwd = __dirname;

  app["package"] = require('../package.json');

  app.os = require('os');

  app.prefix = '/credentials';

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

  app.get(app.prefix + "/ping", function*(next) {
    this.status = 200;
    return (yield next);
  });

  app.get(app.prefix + "/__internal__", function*(next) {
    this.body = {
      service: app["package"].name,
      version: app["package"].version,
      port: app.port,
      env: app.env,
      os: {
        hostname: app.os.hostname(),
        type: app.os.type(),
        platform: app.os.platform(),
        release: app.os.release(),
        uptime: app.os.uptime(),
        loadavg: app.os.loadavg(),
        cpus: app.os.cpus(),
        total_memory: app.os.totalmem(),
        free_memory: app.os.freemem(),
        network_interfaces: app.os.networkInterfaces()
      }
    };
    this.status = 200;
    return (yield next);
  });

  require('./routes/credentials')(app);

  app.listen(app.port);

  console.log("############ || STARTING -> " + (new Date().toISOString()) + " || #####################");

  console.log("| LISTENING on PORT -> " + app.port + " | NODE_ENV -> " + app.env + " | SERVICE -> " + app["package"].name + "/" + app["package"].version);

  console.log("################################################################################");

}).call(this);
