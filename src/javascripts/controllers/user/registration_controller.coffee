angular.module('gruenderviertel').controller 'RegistrationCtrl', (User, TokenContainer, $state, $rootScope, $stateParams, Community) ->

  @state = 1
  @user = $stateParams.user
  @community_list = []
  @form = {}
  @form.user = {}
  @confirmation = false
  @reg_in_progress = false
  @selected = 0
  @filter = 'Branche'
  @bio_characters = 200


  $('#reg_input_password, #reg_input_password_confirmation').on('keyup', () =>
    console.log($('#reg_input_password').val())
    console.log($('#reg_input_password_confirmation').val())
    if $('#reg_input_password').val() == $('#reg_input_password_confirmation').val()
      @confirmation = true
    else
      @confirmation = false
    console.log(@confirmation)
  )

  @resetFile = () -> 
    @form.user.logo = undefined
    e = $("#reg_input_picture")
    e.wrap('<form>').closest('form').get(0).reset()
    e.unwrap()
    e.stopPropagation()
    e.preventDefault()
       

  @init = () =>
    if @user != null
      @state++ 
      @form.user = @user

    Community.get_all().then (response) =>
      @community_list = angular.copy(response)

    console.log("RegistrationCtrl initialized.")


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

  @charLimit = () =>
    if @form.user.description
      @bio_characters = 200 - @form.user.description.length
    else
      @bio_characters = 200

  @init()

  this