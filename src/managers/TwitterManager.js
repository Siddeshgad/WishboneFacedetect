// Generated by CoffeeScript 1.10.0
var MetaMap, MetaTags, TwitterHandles, TwitterManager, models, request, twitter;

request = require('request');

twitter = require('twitter');

models = require('../models');

TwitterHandles = models.twitter_handles;

MetaTags = models.meta_tags;

MetaMap = models.meta_map;

TwitterManager = (function() {
  var _client;

  _client = new twitter({
    consumer_key: 'oe6U2z8nN7u1Zoz3djil6MrQ1',
    consumer_secret: 'kaTQZOdFdnTeJ0b2McZr7Bg3Xcf2nPxx48l8jPKgSVm53FNaGE',
    access_token_key: '1564825038-xATCUZ3YocV6RnsfFe3oVW59JWBnOgQzITPHD0r',
    access_token_secret: 'tnN1PtLFfd2iUbDnduKEeBnHmvcM3SNnZJoOFAIlOnweC'
  });

  function TwitterManager(app) {}

  TwitterManager.postStatus = function(twitterHandle, msg, callback) {
    return _client.post('statuses/update', {
      status: '@' + twitterHandle + ' ' + msg
    }, function(error, tweet, response) {
      if (!error) {
        return callback(tweet);
      } else {
        return callback(error);
      }
    });
  };

  TwitterManager.getHandle = function(name, callback) {
    var params;
    params = {
      q: name
    };
    return _client.get('users/search.json', params, function(error, data, response) {
      if (!error) {
        if (data[0].name === name && data[0].followers_count >= 2000000) {
          return TwitterHandles.create({
            name: data[0].name,
            twitter_id: data[0].id,
            screen_name: data[0].screen_name
          }).then(function(user) {
            return callback(user);
          });
        }
      }
    });
  };

  TwitterManager.addMetaTags = function(authorId, tags, callback) {
    var records, tagIds;
    tagIds = [];
    records = [];

    /*check if few tags exists */
    return MetaTags.findAll({
      where: {
        name: {
          $in: tags
        }
      }
    }).then(function(res) {
      if (res.length) {
        res.forEach(function(tag, key) {
          var index;
          tagIds.push({
            author_id: authorId,
            meta_id: tag.get('id')
          });
          index = tags.indexOf(tag.get('name'));
          if (index) {
            return tags.splice(index, 1);
          }
        });
        if (tags.length) {
          tags.forEach(function(tag, key) {
            return records.push({
              "name": tag
            });
          });
          return MetaTags.bulkCreate(records).then(function() {
            return MetaTags.findAll({
              where: {
                name: {
                  $in: tags
                }
              }
            }).then(function(res) {
              if (res) {
                res.forEach(function(tag, key) {
                  return tagIds.push({
                    author_id: authorId,
                    meta_id: tag.get('id')
                  });
                });
                return MetaMap.bulkCreate(tagIds).then(function() {
                  return callback(tagIds);
                });
              }
            });
          });
        }
      } else {
        tags.forEach(function(tag, key) {
          return records.push({
            "name": tag
          });
        });

        /*None of the tags exists */
        return MetaTags.bulkCreate(records).then(function() {
          return MetaTags.findAll({
            where: {
              name: {
                $in: tags
              }
            }
          }).then(function(res) {
            if (res) {
              res.forEach(function(tag, key) {
                return tagIds.push({
                  author_id: authorId,
                  meta_id: tag.get('id')
                });
              });
              return MetaMap.bulkCreate(tagIds).then(function() {
                return callback(tagIds);
              });
            }
          });
        });
      }
    });
  };

  return TwitterManager;

})();

module.exports = TwitterManager;
