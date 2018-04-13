angular.module('gruenderviertel').directive 'summernote', ($document, $window) =>
  {
    restrict: 'A',
    link: (scope, element, attrs) ->
      $document.ready () ->
        $('#summernote').summernote({
          height: 300,
          minHeight: 300,
          toolbar: [
            ['style', ['bold', 'italic', 'underline','clear']],
            ['font', ['strikethrough', 'superscript', 'subscript']],
            ['fontsize', ['fontsize']],
            ['color', ['color']],
            ['para', ['ul', 'ol', 'paragraph', 'hr']],
            ['height', ['height']],
            ['insert', ['link','picture']],
            ['control', ['undo','redo','fullscreen','help']]
          ]
        })
  }