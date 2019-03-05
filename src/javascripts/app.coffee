# Enter here all used 3rd party angularJS modules
# ui.router: Handles views and states for modularisation of app
# restangular & ngFileUpload: Control the communication between the app and the server.
# ngStorage: API for simple use of the Browser's LocalStorage
# permission: plugin for ui-router; limits state access to predefined attributes
# toaster: Pop-up messages, used for login errors
dependencies = ['ui.router', 'restangular', 'ngStorage', 'permission', 'permission.ui', 'ngFileUpload', 'toaster', 'ngSanitize', 'ui.tinymce']

# Define the App itself.
app = angular.module('gruenderviertel', dependencies)

# Add the interceptors
app.config ($httpProvider) ->
  $httpProvider.interceptors.push('tokenInterceptor')
  $httpProvider.interceptors.push('responseInterceptor')

app.run (User, TokenContainer, $rootScope, $state, $stateParams, Rails, $transitions) ->
  #predefine beginning state and add hook to state transition; used for the goBack function of the Helper.
  $rootScope.$state = $state
  $rootScope.$stateParams = $stateParams

  $transitions.onBefore {}, (transition) ->
    $rootScope.lastState = transition.from()
    $rootScope.lastStateParams = transition.params('from')

  $transitions.onSuccess {}, ($document, $location, $anchorScroll) -> 
    if $location && $location.hash()
      $anchorScroll()
    else
      document.body.scrollTop = document.documentElement.scrollTop = 0

  #$transitions.onError {}, ($state) ->
  #  $state.transitionTo('root.home', {
  #        reload : true
  #      });
  
