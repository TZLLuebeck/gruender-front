angular.module('gruenderviertel').controller 'CreateProjectCtrl', (Project, Community) ->

  @tag_list

  Community.get_all().then (response) =>
    @tag_list = angular.copy(response)

  @selectTag = (community) =>
    i = @tag_list.indexOf(community)
    e = @tag_list[i]
    if e.selected
      e.selected = false
    else
      e.selected = true

  @form = {}

  this