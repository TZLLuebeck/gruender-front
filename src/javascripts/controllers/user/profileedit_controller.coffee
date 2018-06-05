angular.module('gruenderviertel').controller 'ProfileEditCtrl', (User, $state, $stateParams, instance) ->

  @state = 1
  @form = {}
  @form.user = instance
  @predit_in_progress = false

  @init = () =>
    console.log(@form.user)
    delete @form.user.comments
    delete @form.user.projects
    delete @form.user.events
    delete @form.user.posts
    delete @form.user.sent
    delete @form.user.received
    delete @form.user.logo
    console.log(@form.user)
    console.log("ProfileEditCtrl Init")

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
      console.log('profileEditCtrl.saveEdit Error')

   @deleteAccount = () ->
    User.deleteUser(@form.user.id).then (response) =>
      $state.go('root.home')
    , (error) =>
      console.log('profileEditCtrl.deleteAccount Error')


  @init()

  this