request = require('request')
models = require('../models')

class WishboneManager

  constructor: (app) ->


  @getPosts: (callback) ->

    ###HardCoded###
    authToken = '1FEDEA07-3ADB-4702-2542-96614036BAA6'

    body = {
          "page": "0",
          "auth_token": authToken,
          "show_votes": "1"
      }

    request {
      url: 'http://api.getwishboneapp.com/api/communityfeed',
      method: 'PUT'
      headers:
        'authtoken': authToken
      body: JSON.stringify(body)
    }, (error, response, body) ->
      if error
        return callback(error)
      else
        parsedData = JSON.parse(body)
        return callback(parsedData.details)

module.exports = WishboneManager