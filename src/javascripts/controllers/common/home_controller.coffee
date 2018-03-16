angular.module('gruenderviertel').controller 'HomeCtrl', (User, Project, Community, most_used, featured) -> 

  @featured = null
  @most_used = null

  @init = () =>
    Community.preloadTags()
    @featured = angular.copy(featured)
    @most_used = angular.copy(most_used)
    #console.log("Initialized Home Controller.")
    return null

  @init()

this