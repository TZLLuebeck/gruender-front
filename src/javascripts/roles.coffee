angular.module('gruenderviertel').run ($q, PermRoleStore, User) ->

  # Define all relevant roles used by the permission module in the routes.coffee

  PermRoleStore.defineRole 'anonymous', (stateParams) ->
    defer = $q.defer()
    if User.isAuthenticated()
      defer.reject()
    else
      defer.resolve()
    defer.promise

  PermRoleStore.defineRole 'registered', (stateParams) ->
    defer = $q.defer()
    if User.isAuthenticated()
      defer.resolve()
    else
      defer.reject
    defer.promise

  PermRoleStore.defineRole 'administrative', (stateParams) ->
    defer = $q.defer()
    User.getRole().then (role) ->
      if !role
        defer.reject()
      if role = 'admin' || role = 'data'
        defer.resolve()
      else
        defer.reject()
    , -> #not logged in
      defer.reject()
    defer.promise

  PermRoleStore.defineRole 'admin', (stateParams) ->
    defer = $q.defer()
    User.getRole().then (role) ->
      if !role
        defer.reject()
      if role = 'admin' || role = 'data'
        defer.resolve()
      else
        defer.reject()
    , -> #not logged in
      defer.reject()
    defer.promise    