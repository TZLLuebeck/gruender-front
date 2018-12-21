angular.module('gruenderviertel').controller 'CommunityCtrl', (instance, Community, $anchorScroll) ->

  @community = instance
  @icon = instance.icon
  @projects = instance.projects
  @members = instance.users
  @discussions = instance.discussions
  @member_count = instance.member_count
  @project_count = instance.project_count
  @subscribed = instance.subscribed

  @discussion_form = {}
  @comment_form = {}
  @comment_form.content = []

  @init = () =>
    for d in @discussions
      d.created = new Date(Date.parse(d.created_at)).toLocaleString('de-DE')
      d.updated = new Date(Date.parse(d.updated_at)).toLocaleString('de-DE')
      for c in d.comments
        c.created = new Date(Date.parse(c.created_at)).toLocaleString('de-DE')
        c.updated = new Date(Date.parse(c.updated_at)).toLocaleString('de-DE')

  @subscribe = () =>
    Community.join_community(@community.id).then (response) =>
      @member_count++
      @subscribed = response
    , (error) ->
      console.log('CommunityCtrl.subscribe Error')

  @unsubscribe = () =>
    Community.leave_community(@community.id).then (response) =>
      @member_count--
      @subscribed = response
    , (error) ->
      console.log('CommunityCtrl.subscribe Error')

  @startDiscussion = () =>
    message = {title: @discussion_form.title, content: @discussion_form.content}
    Community.post_discussion(@community.id, message).then (response) =>
      @discussion_form = {}
      response.comments = []
      response.created = new Date(Date.parse(response.created_at)).toLocaleString('de-DE')
      response.updated = new Date(Date.parse(response.updated_at)).toLocaleString('de-DE')
      @discussions.push(response)
    , (error) ->
      console.log('CommunityCtrl.startDiscussion Error')

  @comment = (discussion_id, index) =>
    message = {content: @comment_form.content[index]}
    console.log("sending comment")
    Community.post_comment(discussion_id, message).then (response) =>
      console.log("added comment")
      for discussion in @discussions
        if discussion.id == discussion_id
          response.created = new Date(Date.parse(response.created_at)).toLocaleString('de-DE')
          response.updated = new Date(Date.parse(response.updated_at)).toLocaleString('de-DE')
          discussion.comments.push(response)
    , (error) ->
      console.log('CommunityCtrl.comment Error')

  @showEdit = (author, id) ->
    $("#c-body-"+author+"-"+id).addClass("ng-hide")
    $("#c-edit-"+author+"-"+id).removeClass("ng-hide")

  @abortEdit = (author, id) ->
    $("#c-body-"+author+"-"+id).removeClass("ng-hide")
    $("#c-edit-"+author+"-"+id).addClass("ng-hide")

  @editComment = (author, id) =>
    text = $("#c-edit-body-"+author+"-"+id).val()
    Community.editComment(id, text).then (response) =>
      response.updated = new Date(Date.parse(response.updated_at)).toLocaleString('de-DE')
      
      for discussion in @discussions
        for comment in discussion.comments
          if comment.id == id
            comment.content = angular.copy(response.content)
            comment.updated = angular.copy(response.updated)

      $("#c-body-"+author+"-"+id).removeClass("ng-hide")
      $("#c-edit-"+author+"-"+id).addClass("ng-hide")
    , (error) ->
      console.log("Comment edit Error")


  @showDEdit = (author, id) ->
    $("#d-body-"+author+"-"+id).addClass("ng-hide")
    $("#d-edit-"+author+"-"+id).removeClass("ng-hide")

  @abortDEdit = (author, id) ->
    $("#d-body-"+author+"-"+id).removeClass("ng-hide")
    $("#d-edit-"+author+"-"+id).addClass("ng-hide")

  @editDiscussion = (author, id) =>
    text = $("#d-edit-body-"+author+"-"+id).val()
    Community.editDiscussion(id, text).then (response) =>
      response.updated = new Date(Date.parse(response.updated_at)).toLocaleString('de-DE')
      for discussion in @discussions
        if discussion.id == id
          discussion.content = angular.copy(response.content)
          discussion.updated = angular.copy(response.updated)

      $("#d-body-"+author+"-"+id).removeClass("ng-hide")
      $("#d-edit-"+author+"-"+id).addClass("ng-hide")
    , (error) ->
      console.log("Comment edit Error")

  @init()      

  this