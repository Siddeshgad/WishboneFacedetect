request = require('request')
models = require('../models')
TwitterManager = require('./TwitterManager')
TwitterHandles = models.twitter_handles

class AlchemyManager

  constructor: (app) ->

  @getResult: (posts,callback) ->
    users = []

    posts.forEach (post, index) ->
      if post.post_data.post_id == "33359270"
        url = 'http://gateway-a.watsonplatform.net/calls/url/URLGetRankedImageFaceTags?apikey=4525c46ca37ee1d638d9072e56625a58a42e042e&outputMode=json&knowledgeGraph=1&url='+ post.post_data.joined_image 
        request {
          url: url,
          method: 'GET'
        }, (error, response, body) ->
          if error
            return callback(error)
          else
            parsedData = JSON.parse(body)
            if parsedData.status == 'OK'
              msg = post.post_data.tw_share_text
              parsedData.imageFaces.forEach (author, key) ->
                if author.identity && author.identity.disambiguated
                  users.push('name': author.identity.disambiguated.name,'tags': author.identity.disambiguated.subType,'message':msg)

          if posts.length != index + 1
            AlchemyManager.checkUsers users, (res) ->
              return callback(res)


  @checkUsers: (users,callback) ->
    finalUsers = []

    users.forEach (user, key) ->
      TwitterHandles.find({
        where: {
          name: user.name
        }
      }).then (author) ->
        if author
          finalUsers.push({'screen_name':author.screen_name,'message':user.message})
          if(users.length == finalUsers.length)
            return callback(finalUsers)
        else
          TwitterManager.getHandle user.name, (author) ->
            TwitterManager.addMetaTags author.get('id'),user.tags, (result) ->
              finalUsers.push({'screen_name':author.get('screen_name'),'message':user.message})
              if(users.length == finalUsers.length)
                return callback(finalUsers)

        

module.exports = AlchemyManager