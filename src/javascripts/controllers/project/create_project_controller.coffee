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

  @createProject = () ->
    @form.project.tags = []
    for c in @tag_list
      if c.selected
        @form.project.tags.push(c.id)

    @form.project.status = "Published"

    if !@form.project.solution
      @form.project.typus = "Problemstellung"
    else
      @form.project.typus = "Showcase"

    if @form.project.cooptext
      @form.project.coop = true
    else
      @form.project.coop = false

    Project.createProject(@form.project)

  @form = {}
  @form.project = {}

  this