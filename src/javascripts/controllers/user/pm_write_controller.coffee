angular.module('gruenderviertel').controller 'PMWriteCtrl', ($state, User) ->

  @message = null
  @sent = false

  @sendMessage = () =>
    User.sendMessage(@message).then (response) =>
      @sent = true
    , (error) ->
      console.log("PMWriteCtrl.sendMessage Error")
  this