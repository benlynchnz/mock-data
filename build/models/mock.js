(function() {
  var Drivers, Guid, Mock, Reports, _, driverDB, levelup, moment;

  Reports = require('./data/reports');

  Drivers = require('./data/drivers');

  levelup = require('levelup');

  Guid = require('guid');

  _ = require('lodash');

  moment = require('moment');

  driverDB = levelup('./driverDB', {
    valueEncoding: 'json'
  });

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
    var results;
    results = [];
    return new Promise(function(resolve, reject) {
      return driverDB.createReadStream().on("data", function(data) {
        var result;
        result = {
          id: data.key
        };
        _.merge(result, data.value);
        return results.push(result);
      }).on("error", function(err) {
        return reject(err);
      }).on("end", function() {
        return resolve(results);
      });
    });
  };

  Mock.createDriver = function(driver) {
    var id;
    id = Guid.create().value;
    driver.created_at = moment();
    driver.updated_at = moment();
    return new Promise(function(resolve, reject) {
      return driverDB.put(id, driver, function(err) {
        if (err) {
          reject(err);
        }
        return driverDB.get(id, function(err, result) {
          if (err) {
            return reject(err);
          } else {
            result.id = id;
            return resolve(result);
          }
        });
      });
    });
  };

  Mock.updateDriver = function(id, driver) {
    return new Promise(function(resolve, reject) {
      return driverDB.get(id, function(err, result) {
        if (err) {
          reject(err);
        }
        return driverDB.put(id, driver, function(err) {
          if (err) {
            reject(err);
          }
          return driverDB.get(id, function(err, update) {
            if (err) {
              return reject(err);
            } else {
              return resolve(update);
            }
          });
        });
      });
    });
  };

  module.exports = Mock;

}).call(this);
