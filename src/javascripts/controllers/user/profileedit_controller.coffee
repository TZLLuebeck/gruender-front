angular.module('gruenderviertel').controller 'ProfileEditCtrl', (User, $state, $stateParams, instance) ->

  @state = 1
  @form = {}
  @form.user = instance
  @predit_in_progress = false

  @init = () =>


  @goBack = () =>
    if @state <= 0
      $state.go('root.profile')
    else
      @state--

  @proceed = () =>
    if @state < 2
      @state++

  @saveEdit = () ->
    @predit_in_progress = true
    
    User.updateUser(@form.user).then (response) =>
      User.user = response
      $state.go('root.profile')
      @predit_in_progress = false
    , (error) =>
      @predit_in_progress = false
      console.log('preditistrationCtrl.preditister Error')


  @init()

  this