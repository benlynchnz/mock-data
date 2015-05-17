(function() {
  var AWS, Credentials, Joi, _, crypto, db, encrypt, vogels;

  AWS = require('aws-sdk');

  vogels = require('vogels');

  Joi = require('joi');

  _ = require('lodash');

  crypto = require('crypto');

  db = new AWS.DynamoDB();

  vogels.dynamoDriver(db);

  encrypt = function(password) {
    var cipher, crypted;
    cipher = crypto.createCipher('aes-256-cbc', '123456');
    crypted = cipher.update(password, 'utf8', 'hex');
    crypted += cipher.final('hex');
    return crypted;
  };

  Credentials = vogels.define('credential', {
    hashKey: '_id',
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: 'updated_at',
    schema: {
      _id: vogels.types.uuid(),
      user: Joi.string().guid(),
      username: Joi.string(),
      status: Joi.string(),
      password: Joi.string(),
      supplier: Joi.string()
    }
  });

  Credentials.createCredentials = function(json) {
    return new Promise(function(resolve, reject) {
      json.password = encrypt(json.password);
      return Credentials.create(json, function(err, result) {
        if (err) {
          return reject(err);
        } else {
          return resolve(result);
        }
      });
    });
  };

  Credentials.getActiveCredentials = function(_id) {
    return new Promise(function(resolve, reject) {
      return Credentials.get(_id, function(err, result) {
        if (err) {
          return reject(err);
        } else {
          return resolve(result);
        }
      });
    });
  };

  vogels.createTables(function(err) {
    if (err) {
      return console.log(err);
    }
  });

  module.exports = Credentials;

}).call(this);
