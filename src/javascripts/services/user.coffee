angular.module('gruenderviertel').service 'User', (baseREST, $q, $http, Rails, $rootScope, Upload, TokenContainer) ->
  
  #
  # The Company Service contains all functions designed for creating, editing and accessing Company-type resources.
  # The functions all just build a package and create a RESTful query to the server, then return the promise with the result of the operation.
  # In addition, the service handles storing the identification of the current user upon login.
  #

  @user = null
  @newEvents = 0
  @events = []
  @deferreds = {}
  @unauthorized = true

  # CREATE

  createUser = (user) =>
    console.log("Registering.")
    console.log(user)
    defer = $q.defer()
    Upload.upload({
      url: '/api/v1/users/'
      data: {data: user}
      arrayKey: '[]'
    }).then (response) =>
      console.log(response.data.data)
      @user = response.data.data.user
      $rootScope.activeUser = @user
      TokenContainer.set(response.data.data.token)
      @unauthorized = false
      defer.resolve(@user)
    , (error) =>
      defer.reject(error)
    defer.promise

  login = (form) =>
    defer = $q.defer()
    packet = baseREST.one('users').one('login')
    packet.data = {}
    packet.data.username = form.username
    packet.data.password = form.password
    packet.post().then (response) =>
      @user = response.data.user
      $rootScope.activeUser = @user
      TokenContainer.set(response.data.token)
      @unauthorized = false
      $rootScope.$broadcast('event:newEvents')
      defer.resolve(@user)
    , (error) =>
      defer.reject(error)
    defer.promise

  writeMessage = (receiver, content) =>
    defer = $q.defer()
    packet = baseREST.one('users').one('pm')
    packet.data = {receiver: receiver, content: content}
    packet.post().then (response) =>
      defer.resolve(response)
    , (error) =>
      defer.reject(error)
    defer.promise

  checkUsername = (username) =>
    defer = $q.defer()
    packet = baseREST.one('users').one('username')
    packet.username = username
    packet.post().then (response) =>
      defer.resolve(response.data)
    , (error) =>
      defer.reject(error)
    defer.promise

  # READ

  getAll = () ->
    defer = $q.defer()
    baseREST.one('users').get().then (results) ->
      defer.resolve(results.data)
    , (error) ->
      defer.reject(error)
    defer.promise

  getUser = (id) ->
    defer = $q.defer()
    packet = baseREST.one('users')
    if not id
      packet.id = 'me'
    else
      packet.id = id
    packet.get().then (response) =>
      defer.resolve(response.data)
    , (error) ->
      defer.reject(error.error)
    defer.promise

  currentUser = =>
    defer = $q.defer()
    if isAuthenticated()
      defer.resolve(@user)
      defer.promise
    else if @deferreds.me
      return @deferreds.me.promise
    else
      @deferreds.me = defer
      packet = baseREST.one('users')
      packet.id = 'me'

      packet.get().then (response) =>
        @unauthorized = false
        @user = response.data
        $rootScope.activeUser = @user
        @deferreds.me.resolve(response.data)
        delete @deferreds.me
      , (error) =>
        @deferreds.me.reject()
        delete @deferreds.me
      @deferreds.me.promise

  getNewEvents = () =>
    defer = $q.defer()
    packet = baseREST.one('events').one('new')
    packet.get().then (response) =>
      if response.data > 0
        $rootScope.$broadcast('event:newEvents')
        @newEvents = response.data
      defer.resolve(response.data)
    , (error) =>
      defer.reject(error)
    defer.promise

  getEvents = () =>
    defer = $q.defer()
    packet = baseREST.one('events')
    packet.get().then (response) =>
      @events = response.data
      defer.resolve(response.data)
    , (error) ->
      defer.reject(error)
    defer.promise

  getRole = () =>
    defer = $q.defer()
    if $rootScope.activeUser
      defer.resolve($rootScope.activeUser.role)
    else
      defer.reject()
    defer.promise

  # UPDATE

  updateUser = (user) =>
    defer = $q.defer()
    Upload.upload({
      url: '/api/v1/users/'
      data: {data: user}
      arrayKey: '[]'
      method: 'PUT'
    }).then (response) ->
      defer.resolve(response.data.data)
    , (error) ->
      defer.reject(error)
    defer.promise


#  updateUser = (user) =>
#    packet = baseREST.one('users')
#    defer = $q.defer()
#    packet.data = user
#    #Object.assign(packet, user.data[0])
#    packet.put().then (response) ->
#    #baseREST.one('users').customPUT(null, null, user.data[0]).then (response) ->
#      if response.status == 422
#        defer.reject(response.data)
#      else
#        console.log('golden!')
#        defer.resolve(response.data.data)
#    , (error) ->
#      defer.reject(error)
#    defer.promise

  resetPassword = (email) =>
    packet = baseREST.one('users').one('reset')
    defer = $q.defer()
    packet.email = email
    packet.post().then (response) ->
      defer.resolve(response.data)
    , (error) ->
      defer.reject(error)
    defer.promise

  # DELETE

  logout = =>
    defer = $q.defer()
    packet = baseREST.one('users').one('logout')
    packet.remove().then (response) =>
      TokenContainer.deleteToken()
      @user = null
      $rootScope.activeUser = null
      console.log(@user)
      @unauthorized = true
      $rootScope.$broadcast('user:stateChanged')
      defer.resolve(response)
    , (error) =>
      defer.reject(error)
    defer.promise

  logoutLocal = =>
    @user = null
    $rootScope.activeUser = null
    @unauthorized = true
    $rootScope.$broadcast('user:stateChanged')

  deleteUser = (data) =>
    defer = $q.defer()
    packet = baseREST.one('users')
    packet.id = data.id
    packet.current_password = data.current_password
    packet.remove().then (response) =>
      defer.resolve()
    , (error) =>
      @unauthorized = true
      defer.reject(error)
    defer.promise


  # INTERNAL
  isAuthenticated = => !@unauthorized && @user?



  getAll: getAll
  getUser: getUser
  currentUser: currentUser
  updateUser: updateUser
  resetPassword: resetPassword
  checkUsername: checkUsername
  getEvents: getEvents
  getNewEvents: getNewEvents
  login: login
  logout: logout
  logoutLocal: logoutLocal
  deleteUser: deleteUser
  createUser: createUser
  isAuthenticated: isAuthenticated
  getRole: getRole
  writeMessage: writeMessage