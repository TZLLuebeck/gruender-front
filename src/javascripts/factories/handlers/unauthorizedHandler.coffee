angular.module('gruenderviertel').factory 'unauthorizedHandler', ($injector) ->


  #
  # The unauthorizedHandler triggers when the server returns a 401 error, which happens if
  # a restricted route is queried either without or with an expired Oauth2 token.
  # This implies that either we're no longer logged in (expired) or we never were logged in
  # in the first place.
  # The action taken is to reroute the user either to the homepage (auto-logout) or to the
  # registration page (no account).
  #

  handle = (response, deferred) ->
    access  = $injector.get('TokenContainer')
    state = $injector.get('$state')
    console.log(response)
    if response.data.error.error.name == 'invalid_token' 
      console.log("Token invalid:")
      if response.data.error.reason = 'expired'
        console.log("Token expired.")
        access.delete()
        state.go('root.home')
      else
        console.log("No Token.")
        access.delete()
        state.go('root.register')

    deferred.reject(response)
    deferred.promise