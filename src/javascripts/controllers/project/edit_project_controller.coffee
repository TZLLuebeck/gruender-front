angular.module('gruenderviertel').controller 'EditProjectCtrl', (Project, $scope, $state, $stateParams, instance) ->

  @form = angular.copy(instance)

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
    #@form.solution = $('#summernote').summernote('code')
    @form.solution = $('#tinymcearea').tinymce().getContent();
    console.log(@form.solution)
    Project.editProject(@form).then (response) =>
      $state.go('root.project', '{"id": $stateParams.id}', {reload: true})
    , (error) ->
      console.log("EditProjectCtrl.editProject Error")

  @init = () =>
    #$("#summernote").summernote("code", @form.solution);
    $('#tinymcearea').html(@form.solution);
    $('#tinymcearea').tinymce({
      theme : "silver"
    })
    @charLimit()


  @init()

  this