HttpStatus = require('http-status')
WishboneManager = require('../managers/WishboneManager')
AlchemyManager = require('../managers/AlchemyManager')
TwitterManager = require('../managers/TwitterManager')

module.exports = (app, router) ->

  ###Add device to user's profile api###
  router.post '/status', (req, res, next) ->

    WishboneManager.getPosts (posts) ->
      if posts
        AlchemyManager.getResult posts, (response) ->
          console.log(response)
          response.forEach (user, key) ->
            TwitterManager.postStatus user.screen_name, user.message, (finalResponse) ->
              if(response.length == key+1)
                res.status( HttpStatus.OK ).json("success")
      else
        res.status( HttpStatus.NO_CONTENT ).send()