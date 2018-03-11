angular.module('gruenderviertel').controller 'HomeCtrl', (User, Project, Community) -> 

  @featured = []

  @init = () =>
    console.log("Initializing Home Controller.")
    demo_project1 = {name: "Demoprojekt", goal: "To demonstrate a project.", problem: "We have no projects to fill the template with.", solution: "Create a demo project.", likes: 42}
    demo_project2 = {name: "Demoprojekt 2", goal: "To demonstrate a project.", problem: "We have no projects to fill the template with.", solution: "Create a demo project.", likes: 42}
    demo_project3 = {name: "Demoprojekt 3", goal: "To demonstrate a project.", problem: "We have no projects to fill the template with.", solution: "Create a demo project.", likes: 42}
    demo_project4 = {name: "Demoprojekt 4", goal: "To demonstrate a project.", problem: "We have no projects to fill the template with.", solution: "Create a demo project.", likes: 42}
    demo_project5 = {name: "Demoprojekt 5", goal: "To demonstrate a project.", problem: "We have no projects to fill the template with.", solution: "Create a demo project.", likes: 42}
    demo_project6 = {name: "Demoprojekt 6", goal: "To demonstrate a project.", problem: "We have no projects to fill the template with.", solution: "Create a demo project.", likes: 42}
    @featured.push(demo_project1)
    @featured.push(demo_project2)
    @featured.push(demo_project3)
    @featured.push(demo_project4)
    @featured.push(demo_project5)
    @featured.push(demo_project6)

  #REQUIREMENTS


  #MOST LIKED PROJECTS (Featured)

  #MOST USED TAGS (Communities)

  @init()

this