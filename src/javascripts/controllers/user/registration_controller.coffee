angular.module('gruenderviertel').controller 'RegistrationCtrl', (User, TokenContainer, $state, $rootScope) ->

  @form = {user: {}}
  @reg_in_progress = false

  @register = () ->
    console.log(@form)
    @reg_in_progress = true
    User.createUser(@form.user).then (response) ->
      $rootScope.$broadcast('user:stateChanged')
      $state.go('root.home')
    , (error) ->
      @reg_in_progress = false
      console.log('RegistrationCtrl.register Error')

  this