angular.module('gruenderviertel').service 'Event', (baseREST, $q, $rootScope) ->

	@newEvents = []

	$rootScope.$on 'events:checkEvents', (e, state, params) =>
    @checkForNewEvents()

  checkForNewEvents = () =>
  	defer = $q.defer
  	packet = baseREST.one('events').one('new')
  	packet.get().then (response) =>
  		@newEvents = response.data
  		defer.resolve(response.data)
  	, (error) ->
  		console.log('Event.checkForNewEvents Error')
  		defer.reject(error)
  	defer.promise

	getLatestEvents = (amount) =>
  	defer = $q.defer
  	packet = baseREST.one('events')
  	params = {amount: amount}
  	packet.customGET("", params).then (response) =>
  		@newEvents = response.data
  		defer.resolve(response.data)
  	, (error) ->
  		console.log('Event.checkForNewEvents Error')
  		defer.reject(error)
  	defer.promise

  decodeEvents = (events) =>
    decodedEvents = []
    for e in events
      if e.trigger_type == "Comment"
        if e.target_type == "Project"
          e.message = "Neuer Kommentar für Projekt"
          for p in @my_projects
            if p.id = e.target_id
              e.message += ": " + p.name
              break
        else if e.target_type == "Post"
          e.message = "Neuer Kommentar für Diskussion"
          for d in @my_discussions
            if d.id == e.target_id
              e.community_id = d.community_id
              e.message += ": " + d.title
              break
        else
          e.message = "Neues Ereignis."
      else
        e.message = "Neues Ereignis."
      decodedEvents.push(e)


  checkForNewEvents: checkForNewEvents
  getLatestEvents: getLatestEvents
  decodeEvents: decodeEvents