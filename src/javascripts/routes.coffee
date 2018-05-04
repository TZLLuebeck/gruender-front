angular.module('gruenderviertel').config ($stateProvider, $urlRouterProvider, $locationProvider) ->

  #
  # This File defines all the routes/states used by the app.
  #

  console.log("Configuring Routes.")
  # If a non-existing URL was entered, redirect to homepage.
  $urlRouterProvider.otherwise ($injector) -> 
    $state = $injector.get("$state");
    $state.go('root.home');


  $locationProvider.html5Mode(true)
  $locationProvider.hashPrefix('')
  
  $stateProvider
  # The state name is an internal definition of the state. 
  # This is used to change states.
  .state 'root',
    # The URL of a state is appended to the host address if the state is entered.
    # Alternatively, a state with a URL can be entered by accessing the URL in the browser.
    url: ''
    # An abstract state itself cannot be entered. However, it can still become active, if
    # a child state of this state is entered. (Entering any state will also activate all
    # parent states of that state.)
    abstract: true
    # The views section define the views and controllers of the current state.
    # Any view is only displayed and any controller is only active if the specific state
    # or one of its children is active. Any view will be rendered within an <ui-view></ui-view>-0
    # Element within the base document or a parent view.
    views:
      # There can be multiple <ui-view> elements within one document, if they carry an 
      # identifier. This allows for multiple (sub-)views to be displayed on one page.
      # The root state, which is parent to (almost) all states, will display the navbar
      # and the footer in their appropriate sections, while the child states will fill the
      # body <ui-view> element inbetween them.
      'header@':
        # The TemplateURL defines the actual html file that should be loaded.
        templateUrl: 'assets/views/common/navbar.html'
        # The controller is a modular element of the app defined in its own file.
        # It controls the behaviour of the active view. Not every view needs a controller,
        # if the whole functionality is HTML-based.
        controller: 'NavCtrl'
        # The controller alias serves to be able to give the controller a speaking name.
        # While still having a short variable to be used within the code. This can be
        # chosen freely, though idealy duplicates should be avoided.
        controllerAs: 'nav'
      'footer@':
        templateUrl: 'assets/views/common/footer.html'
    # The Resolve part of a state, if present, will try to run all given functions within it
    # and present any acquired result with the key the function is assigned to.
    resolve: 
      identity: (TokenContainer, User, $rootScope) ->
        #If we have an Oauth2 token in our localstorage, then we might still be logged in.
        #Try and retrieve our identity (if the token is not expired).
        if TokenContainer.get()
          console.log('Retrieving User from Token')
          User.currentUser().then (user) ->
            User.user = user
            console.log('User Retrieved from Token')
            $rootScope.$broadcast('user:stateChanged')
          , (error) ->
            console.log('Couldn\'t retrieve User.')

  ############################
  #
  #   Common Routes   
  #     Homepage
  #
  #
  ############################

  .state 'root.home',
    url: '/'
    views:
      'body@':
        templateUrl: 'assets/views/common/home.html'
        controller: 'HomeCtrl'
        controllerAs: 'home'
    resolve:
      most_used: (Community) ->
        Community.getMostUsed().then (response) ->
          return response
        , (error) ->
          return []
      featured: (Project) ->
        Project.getFeatured().then (response) ->
          return response
        , (error) ->
          return []

  ##################################
  #
  # User Routes
  #   Registration Page
  #   Profile page
  #     Account Projects
  #     Account Posts
  #     Account Comments
  #   Update Profile page
  #   
  ##################################
  
  .state 'root.profile',
    url: '/profil/:id'
    views:
      'body@':
        templateUrl: 'assets/views/users/profile.html'
        controller: 'ProfileCtrl'
        controllerAs: 'profile'
    params:
      id: null
    resolve:
      instance: ($stateParams, Helper, User) ->
        id = $stateParams.id
        User.getUser(id).then (response) ->
          return response
        , (error) ->
          Helper.goBack()
          return null        

  .state 'root.register',
    url: '/registrierung'
    views:
      'body@':
        templateUrl: 'assets/views/users/registration.html'
        controller: 'RegistrationCtrl'
        controllerAs: 'reg'
    params:
      user: null

  .state 'root.profile.editprofile',
    url: '/edit'
    views:
      'body@':
        templateUrl: 'assets/views/users/edit.html'
        controller: 'ProfileEditCtrl'
        controllerAs: 'edit'
    resolve:
      instance: (User) ->
        User.currentUser().then (response) ->
          return response
        , (error) ->
          Helper.goBack()
          return null

  .state 'root.passwordrecovery',
    url: '/recover'
    views:
      'body@':
        templateUrl: 'assets/views/users/recovery.html'
        controller: 'RecoveryCtrl'
        controllerAs: 'recovery'

  ##################################
  #
  # Project Routes
  #   Create project
  #   Update project
  #   View Project
  #
  ##################################

  .state 'root.project',
    url: '/projekt/:id'
    views:
      'body@':
        templateUrl: 'assets/views/projects/project.html'
        controller: 'ProjectCtrl'
        controllerAs: 'project'
    params:
      id: null
    resolve:
      instance: ($stateParams, Helper, Project) ->
        id = $stateParams.id
        if id != null
          Project.getOne($stateParams.id).then (response) ->
            return response
          , (error) ->
            Helper.goBack()
            return null
        else
          Helper.goBack()
          return null

  .state 'root.createproject',
    url: '/projekt/neu'
    views:
      'body@':
        templateUrl: 'assets/views/projects/create.html'
        controller: 'CreateProjectCtrl'
        controllerAs: 'create'

  .state 'root.project.editproject',
    url: '/bearbeiten'
    views:
      'body@':
        templateUrl: 'assets/views/projects/edit.html'
        controller: 'EditProjectCtrl'
        controllerAs: 'edit'




  ##################################
  #
  # Community Routes
  #   View Communities
  #   View Community
  #     View Community Projects
  #     View Community Discussions
  #
  ##################################

  .state 'root.communityoverview',
    url: '/communities'
    views:
      'body@':
        templateUrl: 'assets/views/communities/overview.html'
        controller: 'CommunityOverviewCtrl'
        controllerAs: 'coc'
    resolve:
      list: (Helper, Community) ->
        Community.get_all().then (list) ->
          return list
        , (error) ->
          Helper.goBack()
          return null

  .state 'root.community',
    url: '/community/:id'
    views:
      'body@':
        templateUrl: 'assets/views/communities/community.html'
        controller: 'CommunityCtrl'
        controllerAs: 'community'
    params:
      id: null
    resolve:
      instance: ($stateParams, Helper, Community) ->
        id = $stateParams.id
        if id != null
          Community.returnCommunity($stateParams.id).then (response) ->
            return response
          , (error) ->
            Helper.goBack()
            return null
        else
          Helper.goBack()
          return null

  ##################################
  #
  #   Admin Routes
  #     Base state (for permission)
  #       User/Ban Management
  #       Project Management
  #       Community Management
  #       Report Management
  #
  ##################################

  .state 'root.admin',
    url: '/admin'
    abstract: true
    data:
      permissions:
        only: 'admin'
        redirectTo: 'root.home'

  .state 'root.admin.usermanagement',
    url: '/accounts'
    views:
      'body@':
        templateUrl: 'assets/views/admin/users.html'
        controller: 'UserManagementCtrl'
        controllerAs: 'users'
  
  .state 'root.admin.projectmanagement',
    url: '/projekte'
    views:
      'body@':
        templateUrl: 'assets/views/admin/projects.html'
        controller: 'ProjectManagementCtrl'
        controllerAs: 'projects'

  .state 'root.admin.communitymanagement',
    url: '/communities'
    views:
      'body@':
        templateUrl: 'assets/views/admin/communities.html'
        controller: 'CommunitiyManagementCtrl'
        controllerAs: 'communities'

  .state 'root.admin.reports',
    url: '/meldungen'
    views:
      'body@':
        templateUrl: 'assets/views/admin/reports.html'
        controller: 'ReportCtrl'
        controllerAs: 'reports'
    
  ######################################
  #
  #   Singletons
  #   Routes with only a view and no
  #   need for a dedicated controller.
  #
  #
  #
  ######################################


  .state 'root.datenschutz',
   url: '/Datenschutz'
   views:
    'body@':
      templateUrl: 'assets/views/singletons/datenschutz.html'

  .state 'root.fablab',
   url: '/FabLab_Luebeck'
   views:
    'body@':
      templateUrl: 'assets/views/singletons/fablab.html'
  
  .state 'root.geschaeftsmodelle',
   url: '/Geschaeftsmodelle_4.0'
   views:
    'body@':
      templateUrl: 'assets/views/singletons/geschaeftsmodelle.html'
  
  .state 'root.openinnovation',
   url: '/Open_Innovation'
   views:
    'body@':
      templateUrl: 'assets/views/singletons/open_innovation.html'