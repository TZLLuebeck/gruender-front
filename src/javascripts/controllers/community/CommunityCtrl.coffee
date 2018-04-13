angular.module('gruenderviertel').controller 'CommunityCtrl', (instance, Community) ->

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

  @init()      

  this