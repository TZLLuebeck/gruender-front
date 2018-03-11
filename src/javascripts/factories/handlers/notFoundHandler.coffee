angular.module('gruenderviertel').factory 'notfoundHandler', ($injector) ->

  handle = (response, deferred) ->




    deferred.reject(response)
    deferred.promise