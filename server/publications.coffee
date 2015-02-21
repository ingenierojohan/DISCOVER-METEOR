Meteor.publish 'posts', ()->
  return Posts.find()

Meteor.publish 'comments', (postId)->
  check(postId,String)
  Comments.find({postId:postId})

Meteor.publish 'notifications', ->
  return Notifications.find({userId:@userId, read:false})