angular.module('gruenderviertel').factory 'tokenInterceptor', (TokenContainer, Rails) ->

  #
  # This interceptor handles adding the Oauth2 token code to any query made to the REST API.
  #

  request: (config) ->
    # Send AccessToken only to our API
    if config.url.indexOf("/api/v1/") == 0
      token = TokenContainer.get()
      if token
        config.headers['Authorization'] = "Bearer #{token}"
    config


