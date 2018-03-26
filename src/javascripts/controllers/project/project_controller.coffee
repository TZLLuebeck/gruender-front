angular.module('gruenderviertel').controller 'ProjectCtrl', (instance, Project) ->

  @project = instance
  @comment = ""

  @addComment = () =>
    Project.postComment(@project, @comment).then (response) =>
      console.log(response)
      @project.comments.push(response)

  this