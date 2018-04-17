angular.module('gruenderviertel').controller 'RegistrationCtrl', (User, TokenContainer, $state, $rootScope, $stateParams, Community) ->

  @state = 1
  @user = $stateParams.user
  @community_list = []
  @form = {}
  @reg_in_progress = false
  @selected = 0
  @filter = 'Branche'

  @init = () =>
    if @user != null
      @state++ 
      @form.user = @user

    Community.get_all().then (response) =>
      @community_list = angular.copy(response)


  @goBack = () =>
    if @state <= 0
      $state.go('root.home')
    else
      @state--

  @proceed = () =>
    if @state < 5
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

  @register = () =>
    console.log(@form)
    @reg_in_progress = true
    c = []
    for community in @community_list
      if community.selected
        c.push(community.id)

    @form.user.subscriptions = c

    User.createUser(@form.user).then (response) =>
      $rootScope.$broadcast('user:stateChanged')
      $state.go('root.home')
      @reg_in_progress = false
    , (error) =>
      @reg_in_progress = false
      console.log('RegistrationCtrl.register Error')


  @init()

  this