Router.configure(
  layoutTemplate: 'layout'
  loadingTemplate : 'loading'
  notFoundTemplate: 'notFound'
  waitOn: ()->
    return Meteor.subscribe('notifications')
)

#Router.route("/", name: "postsList")

Router.route("/posts/:_id",
  name: "postPage"
  waitOn: ->
    Meteor.subscribe('comments',@params._id)
    Meteor.subscribe('singlePost',@params._id)
  data: ()->
    return Posts.findOne(@params._id)
)

Router.route('/submit',
  name: 'postSubmit'
)

Router.route('/posts/:_id/edit',
  name: 'postEdit'
  waitOn:()->
    return Meteor.subscribe('singlePost',@params._id)
  data: ()->
    return Posts.findOne(this.params._id)
)


@PostsListController = RouteController.extend(
  template: 'postsList'
  increment: 5
  postsLimit: ->
    parseInt(@params.postsLimit) or @increment
  findOptions: ->
    {
    sort: submitted: -1
    limit: @postsLimit()
    }
  subscriptions: ->
    @postsSub = Meteor.subscribe('posts', @findOptions())
    return
  posts: ->
    Posts.find {}, @findOptions()
  data: ->
    hasMore = @posts().count() == @postsLimit()
    nextPath = @route.path(postsLimit: @postsLimit() + @increment)
    {
    posts: @posts()
    ready: @postsSub.ready
    nextPath: if hasMore then nextPath else null
    }
)

Router.route('/:postsLimit?',
  name : 'postsList'
)

requireLogin = ()->
  if (! Meteor.user())
    if (Meteor.loggingIn())
      @render(@loadingTemplate)
    else
      @render('accessDenied')
  else
    @next()

Router.onBeforeAction("dataNotFound",
  only: 'postPage'
)
Router.onBeforeAction(requireLogin,
  only: 'postSubmit'
)