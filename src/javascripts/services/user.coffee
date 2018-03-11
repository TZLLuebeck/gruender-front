angular.module('gruenderviertel').service 'User', (baseREST, $q, $http, Rails, $rootScope, Upload) ->
  
  #
  # The Company Service contains all functions designed for creating, editing and accessing Company-type resources.
  # The functions all just build a package and create a RESTful query to the server, then return the promise with the result of the operation.
  # In addition, the service handles storing the identification of the current user upon login.
  #

  users = baseREST.one('users')
  @user = null
  @deferreds = {}
  @unauthorized = true

  # CREATE

  registerUser = (user) ->
    defer = $q.defer()
    Upload.upload({
      url: '/api/v1/users/'
      data: {data: user}
      }).then (response) =>
      defer.resolve(response.data)
    , (error) =>
      defer.reject(error)
    defer.promise

  adminReg = (user) ->
    defer = $q.defer()
    packet = users.one('create')
    packet.data = user
    packet.post().then (response) =>
      defer.resolve(response.data)
    , (error) =>
      defer.reject(error)
    defer.promise

  # READ

  getAll = () ->
    defer = $q.defer()
    users.get().then (results) ->
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

  getUserPacket = (id) ->
    defer = $q.defer()
    packet = baseREST.one('users')
    unless id
      packet.id = 'me'
    else
      packet.id = id
    packet.get().then (response) ->
      defer.resolve(response)
    , (error) ->
      defer.reject(error)
    defer.promise

  retrieveUser = =>
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

  getRoles = =>
    defer = $q.defer()
    if isAuthenticated()
      defer.resolve(@user.roles)
    else
      retrieveUser().then (user) ->
        defer.resolve(user.roles)
      , ->
        defer.reject()
    defer.promise

  getInterests = (id) =>
    defer = $q.defer()
    packet = baseREST.one('users').one('interests')
    if id
      packet.id = id
    else
      packet.id = @user.id
    packet.get().then (response) ->
      defer.resolve(response)
    , (error) ->
      defer.reject(error)
    defer.promise

  # UPDATE
  updateUser = (user) =>
    packet = baseREST.one('users')
    defer = $q.defer()
    Object.assign(packet, user.data[0])
    user.put().then (response) ->
    #users.customPUT(null, null, user.data[0]).then (response) ->
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
    packet = baseREST.all('users').one('logout')
    packet.remove().then (response) =>
      @user = null
      console.log(@user)
      @unauthorized = true
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
  getUserPacket: getUserPacket
  getRoles: getRoles
  getInterests: getInterests
  retrieveUser: retrieveUser
  updateUser: updateUser
  resetPassword: resetPassword
  logout: logout
  deleteUser: deleteUser
  registerUser: registerUser
  adminReg: adminReg
  isAuthenticated: isAuthenticated