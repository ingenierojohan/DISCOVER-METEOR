Meteor.publish 'posts', (options)->
  check(options,
    sort:Object
    limit:Number)
  return Posts.find({},options)

Meteor.publish('singlePost',(id)->
  check(id, String)
  return Posts.find(id)
)

Meteor.publish 'comments', (postId)->
  check(postId,String)
  Comments.find({postId:postId})

Meteor.publish 'notifications', ->
  return Notifications.find({userId:@userId, read:false})