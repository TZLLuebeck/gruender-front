angular.module('gruenderviertel').controller 'EditProjectCtrl', (Project, $scope, $state, $stateParams, instance) ->

  @form = angular.copy(instance)
  @currentImage = angular.copy(@form.image)

  delete @form.comments
  delete @form.likes
  delete @form.attachment

  @pitch_characters = 200

  @charLimit = () =>
    if @form.goal
      @pitch_characters = 200 - @form.goal.length
    else
      @pitch_characters = 200

  @editProject = () =>
    console.log("Saving.")
    console.log(@form.solution)
    Project.editProject(@form).then (response) =>
      $state.go('root.project', '{"id": $stateParams.id}', {reload: true})
    , (error) ->
      console.log("EditProjectCtrl.editProject Error")

  @resetFile = () ->
    @form.image = undefined
    e = $("#newProject_cover_image")
    e.wrap('<form>').closest('form').get(0).reset()
    e.unwrap()
    #e.stopPropagation()
    #e.preventDefault()

  @init = () =>
    @charLimit()


  @init()

  this