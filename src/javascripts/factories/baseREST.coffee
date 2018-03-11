angular.module('gruenderviertel').factory('baseREST', (Rails, Restangular) ->

  #the baseREST factory creates a Restangular object configured with the details and parameters of the host server.

  Restangular.withConfig (RestangularConfigurer) ->
    host = "#{Rails.database}"
    RestangularConfigurer.setBaseUrl('/api/v1')
    RestangularConfigurer.setDefaultHeaders({'Content-Type':'application/json'})
    RestangularConfigurer.setRequestSuffix('.json')
)

