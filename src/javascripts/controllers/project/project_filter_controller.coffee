angular.module("gruenderviertel").controller 'ProjectFilterCtrl', (projects, $stateParams) ->

  @category = $stateParams.category
  @projects = projects

  this