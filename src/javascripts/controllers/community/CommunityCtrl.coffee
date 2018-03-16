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

  @subscribe = () =>
    Community.join_community(@community.id).then (response) =>
      @subscribed = response
    , (error) ->
      console.log('CommunityCtrl.subscribe Error')

  @unsubscribe = () =>
    Community.leave_community(@community.id).then (response) =>
      @subscribed = response
    , (error) ->
      console.log('CommunityCtrl.subscribe Error')

  @startDiscussion = () =>
    message = {title: @discussion_form.title, content: @discussion_form.content}
    Community.post_discussion(@community.id, message).then (response) =>
      @discussions.push(response)
    , (error) ->
      console.log('CommunityCtrl.startDiscussion Error')

  @comment = (discussion_id) =>
    message = {content: @comment_form.content}
    Community.post_comment(discussion_id, message).then (response) =>
      for discussion in @discussions
        if discussion.id == discussion_id
          discussion.comments.push(response)
    , (error) ->
      console.log('CommunityCtrl.comment Error')

  this