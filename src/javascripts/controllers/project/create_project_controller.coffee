angular.module('gruenderviertel').controller 'CreateProjectCtrl', (Project, Community) ->

  @tag_list

  Community.get_all().then (response) =>
    @tag_list = angular.copy(response)

  @form = {}

  this