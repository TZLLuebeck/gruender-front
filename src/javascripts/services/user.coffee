angular.module('gruenderviertel').service 'User', (baseREST, $q, $http, Rails, $rootScope, Upload, TokenContainer) ->
  
  #
  # The Company Service contains all functions designed for creating, editing and accessing Company-type resources.
  # The functions all just build a package and create a RESTful query to the server, then return the promise with the result of the operation.
  # In addition, the service handles storing the identification of the current user upon login.
  #

  @user = null
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
      TokenContainer.set(response.data.token)
      @unauthorized = false
      defer.resolve(@user)
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
    packet.get().then (response) ->
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
        @deferreds.me.resolve(response.data)
        delete @deferreds.me
      , (error) =>
        @deferreds.me.reject()
        delete @deferreds.me
      @deferreds.me.promise

  # UPDATE
  updateUser = (user) =>
    packet = baseREST.one('users')
    defer = $q.defer()
    Object.assign(packet, user.data[0])
    user.put().then (response) ->
    #baseREST.one('users').customPUT(null, null, user.data[0]).then (response) ->
      if response.status == 422
        defer.reject(response.data)
      else
        console.log('golden!')
        defer.resolve(response.data.data)
    , (error) ->
      defer.reject(error)
    defer.promise

  resetPassword = (accountname) =>
    packet = baseREST.one('users').one('reset')
    defer = $q.defer()
    packet.data = accountname
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
      console.log(@user)
      @unauthorized = true
      $rootScope.$broadcast('user:stateChanged')
      defer.resolve(response)
    , (error) =>
      defer.reject(error)
    defer.promise

  deleteUser = (id) =>
    defer = $q.defer()
    packet = baseREST.one('users')
    packet.id = id
    packet.remove().then (response) =>
      if response.status == 401
        @unauthorized = true
        defer.reject(response.data)
      else
        defer.resolve()
    defer.promise


  # INTERNAL
  isAuthenticated = => !@unauthorized && @user?



  getAll: getAll
  getUser: getUser
  currentUser: currentUser
  updateUser: updateUser
  resetPassword: resetPassword
  login: login
  logout: logout
  deleteUser: deleteUser
  createUser: createUser
  isAuthenticated: isAuthenticated