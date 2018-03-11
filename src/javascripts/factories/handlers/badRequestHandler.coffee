angular.module('gruenderviertel').factory 'badrequestHandler', ($injector) ->

  # The badrequestHandler is triggered when the server returns a 400-Error, which happens due to the REST API failing to validate
  # some parameter data that has been sent to it.
  # The error messages are taken apart and arranged for the clientside error feedback to take over.

  handle = (response, deferred) ->

    console.log('Bad Request')
    console.log(response)
    errors = {}
    for error in response.data.error
      for message in error.messages
        s = message.split(":")
        errors[s[0]] = s[1]

    deferred.reject({status: 400, errors: errors})
    deferred.promise