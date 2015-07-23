(function() {
  var Mock;

  Mock = require('../models/mock');

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
    return app.get("/reports", function*(next) {
      var page, result, rows_per_page;
      rows_per_page = this.request.query['per_page'] || 10;
      page = this.request.query['page'] || 0;
      result = (yield Mock.getReports(page, rows_per_page).then(function(res) {
        return res;
      }));
      this.set('X-Total-Count', 819);
      if (result) {
        this.status = 200;
        return this.body = result;
      } else {
        return this.status = 404;
      }
    });
  };

}).call(this);
