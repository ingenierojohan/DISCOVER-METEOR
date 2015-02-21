Template.errors.helpers(
  errors:()->
    return Errors.find()
)

Template.error.rendered = ->
  error = @data
  console.log("DATA ERROR",@data)
  Meteor.setTimeout (->
    Errors.remove error._id
    return
  ), 3000
  return