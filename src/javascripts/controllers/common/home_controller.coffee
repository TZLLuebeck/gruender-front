angular.module('gruenderviertel').controller 'HomeCtrl', (User, Project, Community, most_used, featured, $state) -> 

  @featured = null
  @most_used = null
  @form = {}

  @init = () =>
    Community.preloadTags()
    @featured = angular.copy(featured)
    @most_used = angular.copy(most_used)
    #console.log("Initialized Home Controller.")
    return null

  @register = () =>
    $state.go('root.register', {user: @form})

  @init()

this