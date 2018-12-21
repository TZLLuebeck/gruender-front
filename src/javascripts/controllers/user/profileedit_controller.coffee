angular.module('gruenderviertel').controller 'ProfileEditCtrl', (User, TokenContainer, $state, $stateParams, instance, $rootScope) ->

  @state = 1
  @form = {}
  @form.user = instance
  @predit_in_progress = false

  @init = () =>
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
      User.user = angular.copy(response)
      $rootScope.activeUser = angular.copy(response)
      $state.go('root.profile', undefined, { reload: true })
      @predit_in_progress = false
    , (error) =>
      @predit_in_progress = false
      console.log('profileEditCtrl.saveEdit Error')

   @deleteAccount = () ->
    data = {}
    data.id = @form.user.id
    data.current_password = @form.user.current_password
    User.deleteUser(data).then (response) =>
      $("#deletion_modal").modal('toggle')
      TokenContainer.deleteToken()
      User.logoutLocal()
      
      $state.go('root.home')
    , (error) =>
      console.log('profileEditCtrl.deleteAccount Error')


  @init()

  this