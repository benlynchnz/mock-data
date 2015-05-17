(function() {
  var chai, expect;

  chai = require('chai');

  expect = chai.expect;

  describe('Test something', function() {
    return it('should return true', function() {
      return expect(1).to.equal(1);
    });
  });

}).call(this);
