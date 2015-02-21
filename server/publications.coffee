Meteor.publish 'posts', ()->
  return Posts.find()

Meteor.publish 'comments', ->
  Comments.find()