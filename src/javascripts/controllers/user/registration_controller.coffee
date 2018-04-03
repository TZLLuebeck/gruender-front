angular.module('gruenderviertel').controller 'RegistrationCtrl', (User, TokenContainer, $state, $rootScope, $stateParams, Community) ->

  @state = 1
  user = $stateParams.user
  @community_list = []
  @form = {user: user}
  @reg_in_progress = false
  @selected = 0
  @filter = 'Branche'

  @init = () =>
    if user == null 
      $state.go('root.home')
    else
      Community.get_all().then (response) =>
        @community_list = angular.copy(response)


  @goBack = () =>
    if @state <= 1
      $state.go('root.home')
    else
      @state--

  @proceed = () =>
    console.log(@form.user)
    if @state < 4
      @state++

  @selectTag = (community) =>
    i = @community_list.indexOf(community)
    e = @community_list[i]
    if e.selected
      @selected--
      e.selected = false
    else
      @selected++
      e.selected = true

  @select = (input) =>
    console.log('filtering by '+input)
    @filter = input

  @filterBy = (item) =>
    return item.typus == @filter

  @register = () ->
    console.log(@form)
    @reg_in_progress = true
    User.createUser(@form.user).then (response) ->
      $rootScope.$broadcast('user:stateChanged')
      $state.go('root.home')
    , (error) ->
      @reg_in_progress = false
      console.log('RegistrationCtrl.register Error')

  @init()

  this