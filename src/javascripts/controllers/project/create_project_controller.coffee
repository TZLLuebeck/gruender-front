angular.module('gruenderviertel').controller 'CreateProjectCtrl', (Project, Community, $state) ->

  @step = 1
  @pitch_characters = 200

  @form = {}
  @form.project = {}
  @form.project.coop = false

  @tag_list

  Community.get_all().then (response) =>
    @tag_list = angular.copy(response)

  @problemPlaceholder = "Beschreibe kurz: Welches Problem hast du gelöst oder möchtest du lösen?"

  @resetFile = () ->
    @form.project.image = undefined
    e = $("#newProject_cover_image")
    e.wrap('<form>').closest('form').get(0).reset()
    e.unwrap()
    #e.stopPropagation()
    #e.preventDefault()

  @selectTag = (community) =>
    i = @tag_list.indexOf(community)
    e = @tag_list[i]
    if e.selected
      e.selected = false
    else
      e.selected = true

  @goBack = () =>
    if @step <= 0
      $state.go('root.home')
    else
      @step--

  @proceed = () =>
    console.log(@form.user)
    if @step < 5
      @step++

  @createProject = () ->
    @form.project.tags = []
    for c in @tag_list
      if c.selected
        @form.project.tags.push(c.id)

    @form.project.status = "Published"

    Project.createProject(@form.project).then (response) ->
      console.log("-------------------------")
      console.log(response)
      console.log("-------------------------")

      $state.transitionTo('root.project', {
        id: response.id
        }, {
          reload : true
        });

  @charLimit = () =>
    if @form.project.goal
      @pitch_characters = 200 - @form.project.goal.length
    else
      @pitch_characters = 200

  @changeTypus = (typus) =>
    if typus == "Open Innovation"
      @problemPlaceholder = "Die Problematik bei Open Innovation-Projekten kann im nächsten Abschnitt mit mehr Details beschrieben werden."
    else
      @problemPlaceholder = "Beschreibe kurz: Welches Problem hast du gelöst oder möchtest du lösen?"
      
    @form.project.typus = typus

  this