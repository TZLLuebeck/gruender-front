angular.module('gruenderviertel').controller 'ProfileCtrl', (instance, $state, $rootScope) ->

  console.log("Looking at profile instance")
  console.log(instance)
  #@user = $rootScope.activeUser
  @user = instance
  @my_projects = angular.copy(@user.projects)
  @my_comments = angular.copy(@user.comments)
  @my_discussions = angular.copy(@user.posts)

  @myPage = false

  console.log(@user)
  
  @decodeEvents = (events) =>
    decodedEvents = []
    for e in events
      if e.trigger_type == "Comment"
        if e.target_type == "Project"
          e.message = "Neuer Kommentar für Projekt"
          for p in @my_projects
            if p.id = e.target_id
              e.message += ": " + p.name
              break
        else if e.target_type == "Post"
          e.message = "Neuer Kommentar für Diskussion"
          for d in @my_discussions
            if d.id == e.target_id
              e.community_id = d.community_id  
              e.message += ": " + d.title
              break
        else
          e.message = "Neues Ereignis."
      else
        e.message = "Neues Ereignis."
      decodedEvents.push(e)

    return decodedEvents

  @visit_event = (e) =>
    console.log(e)
    if e.target_type == "Project"
      $state.go('root.project', {'id': e.target_id})
    else
      $state.go('root.community', {'id': e.community_id})


  @goToComment = (comment) ->
    if comment.parent_type == 'Project'
      $state.go('root.project', {'id': comment.parent_id,'#': "c-"+comment.author+"-"+comment.id })
    else
      console.log("Comment:")
      console.log(comment)
      $state.go('root.community', {'id': comment.grandparent_id,'#': "c-"+comment.author+"-"+comment.id })

  if(@user.id == $rootScope.activeUser.id)
    if @user.events
      @my_events = @decodeEvents(@user.events)
    @myPage = true

  this