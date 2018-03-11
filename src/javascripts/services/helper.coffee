angular.module('gruenderviertel').service 'Helper', ($rootScope, $state) ->

  # The Helper service is a general sevice containing functions that are used in multiple places.


  # This function checks the details of the last State (which is updated via transition hook each time a new state is entered).
  # If the function is called and the last state is valid, we transition into it.
  goBack = (defaultRoute) ->
      prev = $rootScope.lastState
      prevParams = $rootScope.lastStateParams
      console.log(prev)
      console.log(prevParams)
      if prev.name
        $state.go(prev.name, prevParams) 
      else
        $state.go('root.home')
  goBack: goBack