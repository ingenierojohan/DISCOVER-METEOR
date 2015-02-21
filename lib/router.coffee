Router.configure(
  layoutTemplate: "layout"
  loadingTemplate : "loading"
  notFoundTemplate: "notFound"
  waitOn: ()->
    return [Meteor.subscribe("posts"), Meteor.subscribe('comments')]
)

Router.route("/", name: "postsList")

Router.route("/posts/:_id",
  name: "postPage"
  data: ()->
    #console.log("/posts/:_id   THIS= ",@)
    return Posts.findOne(@params._id)
)

Router.route('/submit',
  name: 'postSubmit'
)


Router.route('/posts/:_id/edit',
  name: 'postEdit'
  data: ()->
    return Posts.findOne(this.params._id)
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