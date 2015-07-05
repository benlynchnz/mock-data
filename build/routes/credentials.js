(function() {
  var Credentials, crypto, decrypt;

  Credentials = require('../models/credentials');

  crypto = require('crypto');

  decrypt = function(text) {
    var dec, decipher;
    decipher = crypto.createDecipher('aes-256-cbc', '123456');
    dec = decipher.update(text, 'hex', 'utf8');
    dec += decipher.final('utf8');
    return dec;
  };

  module.exports = function(app) {
    app.post("/", function*(next) {
      var body, user;
      body = this.request.body;
      user = (yield Credentials.createCredentials(body).then(function(res) {
        return res;
      }));
      if (user) {
        this.status = 201;
        return this.body = user;
      } else {
        return this.status = 500;
      }
    });
    app.get("/:id", function*(next) {
      var result, user;
      user = (yield Credentials.getActiveCredentials(this.params.id).then(function(res) {
        return res;
      }));
      if (user) {
        result = user.get();
        result.password = decrypt(user.get('password'));
        this.status = 200;
        return this.body = result;
      } else {
        return this.status = 404;
      }
    });
    return app.get("/users/:user", function*(next) {
      var credentials;
      credentials = (yield Credentials.getCredentialsByUser(this.params.user, this.request.query.supplier).then(function(res) {
        return res;
      }));
      if (credentials) {
        return this.body = credentials;
      } else {
        return this.status = 404;
      }
    });
  };

}).call(this);
