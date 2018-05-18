angular.module('gruenderviertel').controller 'RecoveryCtrl', (User) ->

  @finished = false
  @sent = false
  @name = ""

  @recoverPassword = () =>
    @sent = true
    User.resetPassword(@name).then (response) =>
      @finished = true
      @sent = false
    , (error) =>
      @sent = false
      console.log

  this