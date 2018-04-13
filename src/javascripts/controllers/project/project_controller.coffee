angular.module('gruenderviertel').controller 'ProjectCtrl', (instance, Project, $state, $window) ->

  @project = instance
  @comment = ""

  @init = () =>
    for c in @project.comments
      c.created = new Date(Date.parse(c.created_at)).toLocaleString('de-DE')
      c.updated = new Date(Date.parse(c.updated_at)).toLocaleString('de-DE')

  @viewCommunity = (cid) ->
    url = $state.href('root.community', {id: cid})
    console.log(url)
    $window.open(url,'_blank')


  @addComment = () =>
    Project.postComment(@project, @comment).then (response) =>
      console.log(response)
      @project.comments.push(response)

  @like = () =>
    Project.like(@project.id).then (response) =>
      @project.likes++
    , (error) ->
      console.log("project.like error")


  @unlike = () =>
    Project.unlike(@project.id).then (response) =>
      @project.likes--
    , (error) ->
      console.log("project.dislike error")

  @init()

  this