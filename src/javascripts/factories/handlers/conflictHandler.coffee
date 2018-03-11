angular.module('gruenderviertel').factory 'conflictHandler', ($injector) ->

  handle = (response, deferred) ->




    deferred.reject(response)
    deferred.promise