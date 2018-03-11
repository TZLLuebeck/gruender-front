angular.module('gruenderviertel').factory 'forbiddenHandler', ($injector) ->

  handle = (response, deferred) ->




    deferred.reject(response)
    deferred.promise