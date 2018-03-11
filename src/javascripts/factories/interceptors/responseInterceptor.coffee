angular.module('gruenderviertel').factory 'responseInterceptor', ($q, $injector) ->

  #
  # This interceptor scans the server response for error code and relays the message to the appropriate error
  # handler for further checks.
  #


  responseError: (response) =>
    deferred = $q.defer()
    switch response.status
      when 400
        # 400 Error: Bad Request: 
        handle = $injector.get('badrequestHandler')
        return handle(response, deferred)
      when 401
        # 401 Error: Unauthorized: No proper authentication could be done.
        handle = $injector.get('unauthorizedHandler')
        return handle(response, deferred)
      when 403
        # 403 Error: Forbidden: User could be authenticated, but was not authorized to access this resource.
        handle = $injector.get('forbiddenHandler')
        return handle(response, deferred)
      when 404
        # 404 Error: Not Found: Server could not locate requested resource.
        handle = $injector.get('notfoundHandler')
        return handle(response, deferred)
      when 409
        # 409 Error: Server Conflict: The request somehow conflicts with the current state of the database.
        handle = $injector.get('conflictHandler')
        return handle(response, deferred)
      else
        console.log('Other Error')
        deferred.reject(response)
        return deferred.promise
 
    return response