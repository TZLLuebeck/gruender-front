angular.module('gruenderviertel').controller 'NavCtrl', (User, Event, $rootScope, $state, TokenContainer) ->


  @user = $rootScope.activeUser
  @isAuthenticated = false
  @form = {}
  @admin = false
  @username = "default"
  #@newEvents = @user.events
  @decodedEvents = []

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

  @decodeEvents = (user) =>
    decodedEvents = []
    for e in user.events
      if e.trigger_type == "Comment"
        if e.target_type == "Project"
          e.message = "Neuer Kommentar für Projekt"
          for p in user.projects
            if p.id == e.target_id 
              e.message += ": " + p.name
              break
        else if e.target_type == "Post"
          e.message = "Neuer Kommentar für Diskussion"
          for d in user.posts
            if d.id == e.target_id
              e.community_id = d.community_id
              e.message += ": " + d.title
              break
        else
          e.message = "Neues Ereignis."
      else
        e.message = "Neues Ereignis."
      decodedEvents.push(e)

    return decodedEvents

  @visit_event = (e) =>
    console.log(e)
    if e.target_type == "Project"
      $state.go('root.project', {'id': e.target_id})
    else
      $state.go('root.community', {'id': e.community_id})

  @init = () ->    
    @setLoggedIn(TokenContainer.get())
    @setUsername()
    @isAdmin()
    if @isAuthenticated
    #  @getNewEvents()
      @decodedEvents = @decodeEvents(@user)

  @init()

  this