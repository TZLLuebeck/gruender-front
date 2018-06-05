angular.module('gruenderviertel').controller 'NavCtrl', (User, Event, $rootScope, $state, TokenContainer) ->

  @isAuthenticated = false
  @form = {}
  @admin = false
  @username = "default"
  @newEvents = []

  $rootScope.$on 'user:stateChanged', (e, state, params) =>
    console.log("NavCtrl user:StateChanged")
    @setLoggedIn(TokenContainer.get())
    @setUsername()
    @isAdmin()

  @getNewEvents = () =>
    User.getNewEvents().then (response) =>
      console.log(response)
      @newEvents = response
    , (error) ->
      console.log("NavCtrl.init Error")

  @init = () ->    
    @setLoggedIn(TokenContainer.get())
    @setUsername()
    @isAdmin()
    if @isAuthenticated
      @getNewEvents()
    console.log("NavCtrl Initialized")

  @login = () ->
    User.login(@form).then (response) ->
      $rootScope.$broadcast('user:stateChanged')
    , (error) ->
      console.log("Error during Login")

  @logout = () =>
    User.logout().then () ->
      $state.go('root.home')


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