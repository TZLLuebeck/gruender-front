angular.module('gruenderviertel').service 'Community', ($q, $rootScope, $state, Upload, baseREST) ->

  @community_list = null


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

  join_community = (id) ->
    defer = $q.defer()
    packet = baseREST.one('communities').one('join')
    packet.id = id
    packet.post().then (response) ->
      console.log('Joined Community')
      defer.resolve(response.data)
    , (error) ->
      console.log('Communities.join Error')
      defer.reject(error)
    defer.promise

  post_discussion = (community_id, message) ->
    defer = $q.defer()
    packet = baseREST.one('communities').one('post')
    packet.id = community_id
    packet.data = message
    packet.post().then (response) ->
      console.log('posted discussion')
      defer.resolve(response.data)
    , (error) ->
      console.log('Communities.post Error')
      defer.reject(error)
    defer.promise

  post_comment = (discussion_id, content) ->
    defer = $q.defer()
    packet = baseREST.one('communities').one('comment')
    packet.id = discussion_id
    packet.data = content
    packet.post().then (response) ->
      console.log('posted comment')
      defer.resolve(response.data)
    , (error) ->
      console.log('communities.comment Error')
      defer.reject(error)
    defer.promise

  #READ

  get_all = ->
    defer = $q.defer()
    if @community_list
      defer.resolve(@community_list)
    else
      packet = baseREST.one('communities')
      packet.get().then (response) ->
        console.log('Got all Communities')
        @community_list = response.data
        console.log(@community_list)
        defer.resolve(response.data)
      , (error) ->
        console.log('communities.get_all error')
        defer.reject(error)
    defer.promise

  getMostUsed = ->
    defer = $q.defer()
    packet = baseREST.one('communities').one('popular')
    packet.get().then (response) ->
      defer.resolve(response.data)
      console.log("Got Most used")
    , (error) ->
      console.log('communities.get_most_used error')
      defer.reject(error)
    defer.promise

  preloadTags = ->
    defer = $q.defer()
    get_all().then (response) ->
      defer.resolve("ok")
    , (error) ->
      defer.reject(error)
    defer.promise

  returnCommunity = (id) ->
    defer = $q.defer()
    packet = baseREST.one('communities')
    packet.id = id
    packet.get().then (response) ->
      console.log(response.data)
      defer.resolve(response.data)
    , (error) ->
      console.log ('communities.get_one Error')
      defer.reject(error)
    defer.promise

  #UPDATE

  editDiscussion = (id, newText) ->
    defer = $q.defer()
    packet = baseREST.one('communities').one('post')
    packet.id = id
    data = {}
    data.content = newText
    packet.customPUT(data).then (response) ->
      defer.resolve(response.data)
    , (error) ->
      defer.reject(error)
    defer.promise

  editComment = (id, newText) ->
    defer = $q.defer()
    packet = baseREST.one('communities').one('comment')
    packet.id = id
    data = {}
    data.content = newText
    packet.customPUT(data).then (response) ->
      defer.resolve(response.data)
    , (error) ->
      defer.reject(error)
    defer.promise

  #DELETE

  leave_community = (id) ->
    defer = $q.defer()
    packet = baseREST.one('communities').one('leave')
    packet.id = id
    packet.remove().then (response) ->
      defer.resolve(response.data)
    , (error) ->
      console.log('communities.leave_community Error')
      defer.reject(error)
    defer.promise

  create_community: create_community
  join_community: join_community
  post_discussion: post_discussion
  post_comment: post_comment
  get_all: get_all
  getMostUsed: getMostUsed
  preloadTags: preloadTags
  editDiscussion: editDiscussion
  editComment: editComment
  returnCommunity: returnCommunity
  leave_community: leave_community