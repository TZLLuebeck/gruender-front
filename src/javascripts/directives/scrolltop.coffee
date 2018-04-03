angular.module('gruenderviertel').directive 'scrolltop', ($document, $window) =>
  {
    restrict: 'A',
    link: (scope, element, attrs) ->
      element.bind 'click', () =>
        $window.scrollTo(0, 0);
      scope.$on '$destroy', () -> 
        element.unbind 'click'
  }