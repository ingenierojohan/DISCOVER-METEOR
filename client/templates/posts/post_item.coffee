Template.postItem.helpers(
  domain: ()->
    a = document.createElement('a')
    a.href = @url
    return a.hostname

  log : (parentContext)->
    #console.log(@)
    #console.log(parentContext)

  ownPost :()->
    a = @userId == Meteor.userId()
    console.log a
    return a
)