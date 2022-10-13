script "Global_Project_Create_Menu"
--> MetaData
-
license: GPLv3
name: Global_Project_Create_Menu
type: modules
version: 0.2


--. Menu | Props
-
getprop menu_CheckTarget [projectName]
   put library_FetchProjectFolder (projectName) into projectFolder
   if projectFolder is empty then
      return false
   else
      return true
   end if
end menu_CheckTarget


--> Global | Project | Create | Menu
-
on menu_CreateNewProject
   project_AskCreate
end menu_CreateNewProject

on _
end _

on menu_CreateProjectMenu projectName
   put _askMenuTitle (projectName) into gMenuTitle
   put project_GetFolder (projectName) into projectFolder
   project_CreateMenu projectFolder, gMenuTitle
   put the result into controllerStackObject
   edit the script of controllerStackObject
end menu_CreateProjectMenu

on menu_CreateRecentMenu projectName
   put lcw_Ask ("What short name do you want for the Recent menu?", projectName) into shortName
   put ide_ConstructMenuTitle (shortName, "Recent") into gMenuTitle
   
   put project_GetFolder (projectName) into projectFolder
   project_CreateMenu projectFolder, gMenuTitle
   put the result into controllerStackObject
   edit the script of controllerStackObject
end menu_CreateRecentMenu

on menu_CreateHandlerMenu projectName
   put lcw_Ask ("What short name do you want for the Handler menu?", projectName) into shortName
   put ide_ConstructMenuTitle (shortName, "List") into gMenuTitle
   
   put project_GetFolder (projectName) into projectFolder
   project_CreateMenu projectFolder, gMenuTitle
   put the result into controllerStackObject
   edit the script of controllerStackObject
end menu_CreateHandlerMenu

on _
end _

on menu_CreateProjectLibrary projectName
   put "Choose a name for your script-only library stack...." into someQuestion
   set the itemdelimiter to "_"
   put "lib_" &  item -1 of projectName into suggestedAnswer 
   put lcw_Ask (someQuestion, suggestedAnswer) into stackName
   
   put project_GetFolder (projectName) into projectFolder
   project_CreateStack projectFolder, stackName, "libraries", "library"
   put the result into homeStackPath
   
   start using stack stackName
   lcw_Notify ("Stack" && kwote (stackName) && "is now known and used!")
   edit the script of stack stackName
   finder_Reveal projectFolder
end menu_CreateProjectLibrary

on menu_CreateProjectModel projectName
   put "Choose a name for your script only model stack...." into someQuestion
   put "model_XXX" into suggestedAnswer
   project_CreateScriptOnlyStack "models", someQuestion, suggestedAnswer, projectName
end menu_CreateProjectModel

on menu_CreateProjectBehavior projectName
   put "Choose a name for your script-only behavior stack...." into someQuestion
   put "behavior_XXX" into suggestedAnswer
   project_CreateScriptOnlyStack "behaviors", someQuestion, suggestedAnswer, projectName
end menu_CreateProjectBehavior

on _
end _

on menu_CreateModule homeStackName
   put "Choose a name for your new module...." into someQuestion
   put the clipboarddata ["text"] into suggestedAnswer
   set the itemdelimiter to "|"
   if item 1 of suggestedAnswer is not "View" then
      put "View|Test" into suggestedAnswer
   end if
   put lcw_Ask (someQuestion, suggestedAnswer) into moduleStackName
   
   put project_GetFolder (homeStackName) into projectFolder
   if projectFolder is empty then
      answer warning "Cannot locate project folder!"
      put projectFolder
      breakpoint
      exit to top
   end if
   put project_ConstructFolder ("modules", projectFolder) into rootModuleFolder
   
   project_CreateModule moduleStackName, rootModuleFolder
end menu_CreateModule

on menu_CreateView projectName
   breakpoint
   template_ConstructStackFromObject scriptObject
end menu_CreateView

on _
end _

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Global | Project | Create | Menu | Props
-
--> Global | Project | Create | Menu | Disabled
-

--> Dev | Menu
-
on menu_TestProjectName homeStackName
   put homeStackName
end menu_TestProjectName


--> Private
-
private function _askMenuTitle projectName
   put line 1 of the clipboarddata ["text"] into maybeMenuTitle
   if word -1 of maybeMenuTitle = "Menu" then
      put maybeMenuTitle into suggestedAnswer
   else
      set the itemdelimiter to "_"
      put "Global |" && item -1 of projectName && "| Menu" into suggestedAnswer
   end if
   
   put "What is the name of your global menu...." into someQuestion
   put lcw_Ask (someQuestion, suggestedAnswer) into gMenuTitle
   return gMenuTitle
end _askMenuTitle
