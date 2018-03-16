angular.module('gruenderviertel').controller 'ProfileCtrl', (instance, $state) ->

  @user = instance
  @my_projects = angular.copy(@user.projects)
  @my_comments = angular.copy(@user.comments)
  @my_discussions = angular.copy(@user.posts)

  console.log(instance)

  @goToComment = (comment) ->
    if comment.parent_type == 'Project'
      $state.go('root.project', comment.parent_id)
    else
      $state.go('root.community', comment.parent_id)

  this