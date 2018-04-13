angular.module('gruenderviertel').service 'Project', (baseREST, $q, Upload) ->


  #
  # The Interests Service contains all functions designed for creating, editing and accessing Interest-type resources.
  # The functions all just build a package and create a RESTful query to the server, then return the promise with the result of the operation.
  #

  #CREATE

  createProject = (project) ->
    defer = $q.defer()
    Upload.upload({
      url: '/api/v1/projects/'
      data: {data: project}
      arrayKey: '[]'
      }).then (response) =>
      defer.resolve(response.data)
    , (error) =>
      defer.reject(error)
    defer.promise

  postComment = (project, content) ->
    defer = $q.defer()
    packet = baseREST.one('projects').one('comment')
    packet.id = project.id
    packet.content = content
    packet.post().then (response) ->
      console.log('comment posted')
      defer.resolve(response.data)
    , (error) ->
      console.log('Project.postComment ERror')
    defer.promise

  like = (project_id) ->
    defer = $q.defer()
    packet = baseREST.one('projects').one('like')
    packet.id = project_id
    packet.post().then (response) ->
      console.log('like/unlike sent')
      defer.resolve(response.data)
    , (error) ->
      console.log('Project.like Error')
      defer.reject(error)
    defer.promise

  #READ

  getAll = ->
    defer = $q.defer()
    packet = baseREST.one('projects')
    packet.get().then (response) ->
        console.log('Got Interests')
        defer.resolve(response.data)
    , (error) ->
        console.log('Project.getAll Error')
        defer.reject(error.data.error)
    defer.promise

  getOne = (id) -> 
    defer = $q.defer()
    packet = baseREST.one('projects')
    packet.id = id
    packet.get().then (response) ->
      console.log('Got Project')
      defer.resolve(response.data)
    , (error) ->
      console.log('Project.getOne Error')
      defer.reject(error)
    defer.promise

  getFeatured = () ->
    defer = $q.defer()
    packet = baseREST.one('projects').one('featured')
    packet.get().then (response) ->
      console.log('Got Featured')
      defer.resolve(response.data)
    , (error) ->
      console.log('Project.getFeatured Error')
      defer.reject(error)
    defer.promise

  #UPDATE

  editProject = (project) ->
    defer = $q.defer()
    Upload.upload({
      url: '/api/v1/projects/'
      data: {data: project}
      arrayKey: '[]'
      }).then (response) =>
      defer.resolve(response.data)
    , (error) =>
      defer.reject(error)
    defer.promise


  #DELETE

  removeProject = (id) ->
    defer = $q.defer()
    packet = baseREST.one('projects')
    packet.id = id
    packet.delete.then (response) ->
      conosle.log('Remove Interest')
      defer.resolve(response.data)
    , (error) ->
      console.log('Interest.removeProject failed')
      defer.reject(error)
    defer.promise


  createProject: createProject
  postComment: postComment
  like: like
  getAll: getAll
  getOne: getOne
  editProject: editProject
  removeProject: removeProject
  getFeatured: getFeatured