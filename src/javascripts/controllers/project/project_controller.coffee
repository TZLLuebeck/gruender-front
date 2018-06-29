angular.module('gruenderviertel').controller 'ProjectCtrl', (User, instance, Project, $state, $window, $anchorScroll, $location) ->

  @project = instance
  @comment = ""
  @moreProjects = []
  @user = User
  @likes = @project.likes
  @liked = false

  @init = () =>
    console.log("Projekt:")
    console.log(@project)

    for c in @project.comments
      c.created = new Date(Date.parse(c.created_at)).toLocaleString('de-DE')
      c.updated = new Date(Date.parse(c.updated_at)).toLocaleString('de-DE')
    @getOtherProjects()

  @viewCommunity = (cid) ->
    url = $state.href('root.community', {id: cid})
    console.log(url)
    $window.open(url,'_blank')


  @addComment = () =>
    Project.postComment(@project, @comment).then (response) =>
      @comment = ""
      response.created = new Date(Date.parse(response.created_at)).toLocaleString('de-DE')
      response.updated = new Date(Date.parse(response.updated_at)).toLocaleString('de-DE')
      console.log(response)
      @project.comments.push(response)

  @like = () =>
    Project.like(@project.id).then (response) =>
      if response
        @project.liked = true
        @likes++
      else
        @project.liked = false
        @likes--
    , (error) ->
      console.log("project.like error")

  @getFileName = () =>
    if @project.attachment.url
      path = @project.attachment.url.split("/")
      return path[path.length-1]

    return ""

  @getOtherProjects = () =>
    Project.getMore(@project.id).then (response) =>
      console.log(response)
      @moreProjects = response
    , (error) =>
      @moreProjects = []
      console.log("Project.getMore: Error")

  @init()

  this