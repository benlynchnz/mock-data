(function() {
  var Drivers, Mock, Reports;

  Reports = require('./data/reports');

  Drivers = require('./data/drivers');

  Mock = function() {};

  Mock.getReports = function(page, rows) {
    return new Promise(function(resolve, reject) {
      return Reports.get(page, rows, function(err, result) {
        if (err) {
          return reject(err);
        } else {
          return resolve(result);
        }
      });
    });
  };

  Mock.getDrivers = function(count) {
    return new Promise(function(resolve, reject) {
      return Drivers.get(count, function(err, result) {
        if (err) {
          return reject(err);
        } else {
          return resolve(result);
        }
      });
    });
  };

  module.exports = Mock;

}).call(this);
