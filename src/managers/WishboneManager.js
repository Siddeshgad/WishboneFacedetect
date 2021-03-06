// Generated by CoffeeScript 1.10.0
var WishboneManager, models, request;

request = require('request');

models = require('../models');

WishboneManager = (function() {
  function WishboneManager(app) {}

  WishboneManager.getPosts = function(callback) {

    /*HardCoded */
    var authToken, body;
    authToken = '1FEDEA07-3ADB-4702-2542-96614036BAA6';
    body = {
      "page": "0",
      "auth_token": authToken,
      "show_votes": "1"
    };
    return request({
      url: 'http://api.getwishboneapp.com/api/communityfeed',
      method: 'PUT',
      headers: {
        'authtoken': authToken
      },
      body: JSON.stringify(body)
    }, function(error, response, body) {
      var parsedData;
      if (error) {
        return callback(error);
      } else {
        parsedData = JSON.parse(body);
        return callback(parsedData.details);
      }
    });
  };

  return WishboneManager;

})();

module.exports = WishboneManager;
