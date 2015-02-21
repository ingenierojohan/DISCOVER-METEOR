Comments = new Mongo.Collection('comments')
@Comments = Comments

Meteor.methods
  commentInsert: (commentAttributes) ->
    check @userId, String
    check commentAttributes,
      postId: String
      body: String
    user = Meteor.user()
    post = Posts.findOne(commentAttributes.postId)
    if !post
      throw new (Meteor.Error)('invalid-comment', 'You must comment on a post')
    comment = _.extend(commentAttributes,
      userId: user._id
      author: user.username
      submitted: new Date)

    #update the post whit de numbre of comments
    Posts.update(comment.postId,{$inc:{commentsCount:1}})

    comment._id = Comments.insert comment

    # Ahora Creamos la Notificacion
    createCommentNotification(comment)

    return comment._id
