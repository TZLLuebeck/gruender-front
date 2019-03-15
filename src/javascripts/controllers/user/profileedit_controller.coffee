angular.module('gruenderviertel').controller 'ProfileEditCtrl', (User, TokenContainer, $state, $stateParams, instance, $rootScope, $scope) ->

  @state = 1
  @form = {}
  @form.user = instance
  @predit_in_progress = false
  @wrong_password = false

  @validation = {}
  @validation.confirmation = true

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
    @wrong_password = false
    @predit_in_progress = true
    
    User.updateUser(@form.user).then (response) =>
      User.user = angular.copy(response)
      $rootScope.activeUser = angular.copy(response)
      $state.go('root.profile', undefined, { reload: true })
      @predit_in_progress = false
    , (error) =>
      @predit_in_progress = false
      console.log('profileEditCtrl.saveEdit Error')
      if(error.data.error.name == "wrong_password")
        @wrong_password = true

  @resetFile = () -> 
    @form.user.logo = undefined
    e = $("#predit_input_picture")
    e.wrap('<form>').closest('form').get(0).reset()
    e.unwrap()
    #e.stopPropagation()
    #e.preventDefault()

  @deleteAccount = () ->
    @wrong_password = false
    $("#deletion_modal").modal('hide')
    data = {}
    data.id = @form.user.id
    data.current_password = @form.user.current_password
    User.deleteUser(data).then (response) =>
      TokenContainer.deleteToken()
      User.logoutLocal()
      
      $state.go('root.home')
    , (error) =>
      console.log('profileEditCtrl.deleteAccount Error')
      if(error.data.error.name == "wrong_password")
        @wrong_password = true

  @checkPasswordConfirmation = (pw, pwc) ->
    if pw == pwc
      return true
    else
      return false

  $('#predit_input_password, #predit_input_password_confirmation').on('keyup', () =>
    console.log(@form.user.password + " - " + $('#predit_input_password').val())
    console.log(@form.user.password_confirmation + " - " + $('#predit_input_password_confirmation').val())
    @validation.confirmation = @checkPasswordConfirmation($('#predit_input_password').val(), $('#predit_input_password_confirmation').val()) 
    $scope.$apply()
    console.log(@validation)
  )


  @init()

  this