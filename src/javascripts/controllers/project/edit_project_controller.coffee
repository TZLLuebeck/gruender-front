angular.module('gruenderviertel').controller 'EditProjectCtrl', (Project, $scope, $state, $stateParams) ->

  @form = $scope.$parent.form


  @editProject = () =>
    Project.editProject().then (response) =>
      $state.go('root.project', '{"id": $stateParams.id}')
    , (error) ->
      console.log("EditProjectCtrl.editProject Error")

	this