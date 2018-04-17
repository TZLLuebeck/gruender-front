angular.module('gruenderviertel').directive 'anchormove', ($document, $window, $anchorScroll, $location) =>
  {
    restrict: 'A',
    link: (scope, element, attrs) ->
      if $location.hash()
        $anchorScroll()
      else
        document.body.scrollTop = document.documentElement.scrollTop = 0
  }