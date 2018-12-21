angular.module('gruenderviertel').controller 'RecoveryCtrl', (User) ->

  @finished = false
  @sent = false
  @email = ""

  console.log("RecoveryCtrl initiated.")

  @recoverPassword = () =>
    @sent = true
    User.resetPassword(@email).then (response) =>
      @finished = true
    , (error) =>
      @sent = false
      console.log

  this