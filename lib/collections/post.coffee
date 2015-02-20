Posts = new Mongo.Collection('posts')

Posts.allow(
  insert: (userId, doc) ->
    #only allow posting if you are logged in
    console.log(!!userId)
    return !! userId
)

@Posts = Posts