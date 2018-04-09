angular.module('gruenderviertel').controller 'HomeCtrl', ($rootScope, TokenContainer, User, Project, Community, most_used, featured, $state) -> 

  @featured = null
  @most_used = null
  @form = {}
  @isAuthenticated = User.isAuthenticated()

  $rootScope.$on 'user:stateChanged', (e, state, params) =>
    console.log("Hometrl user:StateChanged")
    @isAuthenticated = User.isAuthenticated()
    console.log(@isAuthenticated)

  @setLoggedIn = (isLoggedIn) => 
    @isAuthenticated = !!isLoggedIn
    console.log('Logged In Status: '+@isAuthenticated)

  @init = () =>
    Community.preloadTags()
    @featured = angular.copy(featured)
    @most_used = angular.copy(most_used)
    console.log("HomeCtrl Initialized")
    return null

  @register = () =>
    $state.go('root.register', {user: @form})

  @init()

this