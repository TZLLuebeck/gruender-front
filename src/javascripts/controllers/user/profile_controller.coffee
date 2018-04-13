angular.module('gruenderviertel').controller 'ProfileCtrl', (instance, $state) ->

  @user = instance
  @my_projects = angular.copy(@user.projects)
  @my_comments = angular.copy(@user.comments)
  @my_discussions = angular.copy(@user.posts)

  console.log(instance)

  @goToComment = (comment) ->
    if comment.parent_type == 'Project'
      $state.go('root.project', {'id': comment.parent_id,'#': "c-"+comment.author+"-"+comment.id })
    else
      $state.go('root.community', {'id': comment.parent_id,'#': "c-"+comment.author+"-"+comment.id })

  this