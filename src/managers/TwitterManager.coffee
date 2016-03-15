request = require('request')
twitter = require('twitter')
models = require('../models')
TwitterHandles = models.twitter_handles
MetaTags = models.meta_tags
MetaMap = models.meta_map

class TwitterManager

  _client = new twitter({
    consumer_key: 'oe6U2z8nN7u1Zoz3djil6MrQ1',
    consumer_secret: 'kaTQZOdFdnTeJ0b2McZr7Bg3Xcf2nPxx48l8jPKgSVm53FNaGE',
    access_token_key: '1564825038-xATCUZ3YocV6RnsfFe3oVW59JWBnOgQzITPHD0r',
    access_token_secret: 'tnN1PtLFfd2iUbDnduKEeBnHmvcM3SNnZJoOFAIlOnweC'
    })

  constructor: (app) ->

  @postStatus: (twitterHandle,msg,callback) ->
    _client.post 'statuses/update', {status: '@' + twitterHandle + ' ' + msg}, (error, tweet, response)->
      if !error
      	return callback(tweet)
      else
      	return callback(error)


  @getHandle: (name,callback) ->

    params = {q: name};
    _client.get 'users/search.json', params, (error, data, response) ->
      if !error
        if data[0].name == name && data[0].followers_count >= 2000000
          TwitterHandles.create(
            name: data[0].name
            twitter_id: data[0].id
            screen_name: data[0].screen_name
          ).then (user) ->
            return callback(user)


  @addMetaTags: (authorId,tags,callback) ->
    tagIds = []
    records = []

    ###check if few tags exists###
    MetaTags.findAll({
      where: {
        name: {
          $in: tags
        }
      }
    }).then (res) ->
      if res.length
        res.forEach (tag, key) ->
          tagIds.push({author_id: authorId, meta_id:tag.get('id')})
          index = tags.indexOf(tag.get('name'))
          if index
            tags.splice(index, 1)

        if tags.length
          tags.forEach (tag, key) ->
            records.push({"name":tag})

          MetaTags.bulkCreate(records).then () ->
            MetaTags.findAll({
              where: {
                name: {
                  $in: tags
                }
              }
            }).then (res) ->
              if res
                res.forEach (tag, key) ->
                  tagIds.push({author_id: authorId, meta_id:tag.get('id')})

                MetaMap.bulkCreate(tagIds).then () ->
                  return callback(tagIds)
      else
        tags.forEach (tag, key) ->
          records.push({"name":tag})

        ###None of the tags exists###
        MetaTags.bulkCreate(records).then () ->
          MetaTags.findAll({
            where: {
              name: {
                $in: tags
              }
            }
          }).then (res) ->
            if res
              res.forEach (tag, key) ->
                tagIds.push({author_id: authorId, meta_id:tag.get('id')})

              MetaMap.bulkCreate(tagIds).then () ->
                return callback(tagIds)
          

module.exports = TwitterManager