Posts = new Mongo.Collection('posts')
@Posts = Posts


Posts.allow(
  update: (userId, post)->
    return ownsDocument(userId, post)
  remove: (userId, post)->
    return ownsDocument(userId, post)
)

Posts.deny(
  update: (userId, post, fieldNames)->
    console.log("fieldNames",fieldNames)
  #may only edit the following two fields:
    return (_.without(fieldNames, 'url', 'title').length > 0)
)


@validatePost = (post) ->
  errors = {}
  if !post.title
    errors.title = 'Please fill in a headline'
  if !post.url
    errors.url = 'Please fill in a URL'
  errors


Posts.deny update: (userId, post, fieldNames, modifier) ->
  errors = validatePost(modifier.$set)
  errors.title or errors.url




Meteor.methods
  postInsert: (postAttributes) ->
    console.log(postAttributes)
    check Meteor.userId(), String
    check postAttributes,
      title: String
      url: String

    errors = validatePost(postAttributes)
    if errors.title or errors.url
      throw new Meteor.Error('invalid-post', "You must set a title and URL for your post")

    postWithSameLink = Posts.findOne(url:postAttributes.url)
    if postWithSameLink
      return {
        postExists:true
        _id:postWithSameLink._id
      }


    user = Meteor.user()
    post = _.extend(postAttributes,
      userId: user._id
      author: user.username
      submitted: new Date)
    postId = Posts.insert(post)
    return { _id: postId }




