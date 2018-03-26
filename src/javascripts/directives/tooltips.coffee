angular.module('gruenderviertel').directive 'tooltips', ($document, $window) =>
  {
    restrict: 'A',
    link: (scope, element, attrs) ->
      $document.ready () ->
        $('[data-toggle="tooltip"]').tooltip()
        $('[data-toggle="popover"]').popover()
  }