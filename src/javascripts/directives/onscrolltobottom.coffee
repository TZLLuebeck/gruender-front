angular.module('gruenderviertel').directive 'onScrollToBottom', ($document, $window) =>
  {
    restrict: 'A',
    link: (scope, element, attrs) ->
      $document.bind "scroll", () =>
        if $window.pageYOffset + $window.innerHeight >= $document.height()
          scope.$apply(attrs.onScrollToBottom)
      scope.$on '$destroy', () -> 
        $document.unbind 'scroll'
  }