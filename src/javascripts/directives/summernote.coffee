angular.module('gruenderviertel').directive 'summernote', ($document, $window) =>
  {
    restrict: 'A',
    link: (scope, element, attrs) ->
      $document.ready () ->
        $('#summernote').summernote({
          height: 300,
          minHeight: 300
          });
  }