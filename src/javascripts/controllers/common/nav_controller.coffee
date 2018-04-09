angular.module('gruenderviertel').controller 'NavCtrl', (User, $rootScope, $state, TokenContainer) ->

  @isAuthenticated = false
  @form = {}
  @admin = false
  @username = "default"

  $rootScope.$on 'user:stateChanged', (e, state, params) =>
    console.log("NavCtrl user:StateChanged")
    @setLoggedIn(TokenContainer.get())
    @setUsername()
    @isAdmin()

  @init = () ->
    @setLoggedIn(TokenContainer.get())
    @setUsername()
    @isAdmin()
    console.log("NavCtrl Initialized")

  ##################
  # Active Functions
  @login = () ->
    User.login(@form).then (response) ->
      $rootScope.$broadcast('user:stateChanged')
    , (error) ->
      console.log("Error during Login")

  @logout = () =>
    User.logout().then () ->
      $state.go('root.home')


  ###################
  # Passive Functions
  @setUsername = () =>
    if @isAuthenticated
      User.currentUser().then (response) =>
        @username = angular.copy(response.username)
      , (error) ->
        @username = "Angemeldet"
        console.log("setUsername: error")

  @setLoggedIn = (isLoggedIn) => 
    @isAuthenticated = !!isLoggedIn
    console.log('Logged In Status: '+@isAuthenticated)

  @isAdmin = () =>
    console.log(User.user)
    if User.user
      console.log(User.user.role)
      if User.user.role == 'admin'
        @admin = true
      else
        @admin = false
    else
      @admin = false

  @init()

  this