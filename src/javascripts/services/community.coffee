angular.module('gruenderviertel').service 'Community', ($rootScope, $state, Upload) ->

  #CREATE
  create_community = (community) ->
    defer = $q.defer()
    packet = baseREST.one('communities')
    packet.post().then (response) ->
      console.log('Community Create')
      defer.resolve(response.data)
    , (error) ->
      console.log ('Communities.create Error')
      defer.reject(error)
    defer.promise


  #READ

  get_all = ->
    defer = $q.defer()
    packet = baseREST.one('communities')
    packet.get().then (response) ->
      console.log('Got all Communities')
      defer.resolve(response.data)
    , (error) ->
      console.log('communities.get_all error')
      defer.reject(error)
    defer.promise


  #UPDATE


  #DELETE