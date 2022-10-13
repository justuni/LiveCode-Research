script "Global_Controllers_Tree_Line_Menu"
--> MetaData
-
license: GPLv3
name: Global_Controllers_Tree_Line_Menu
type: controller
version: 0.2


--> Global | Controllers | Tree | Line | Menu
-
on menu_TestMenu indexView
   put the selected_Index of indexView into stackName
   -- put the menu_Titles of stack stackName
   put the menu_GlobalTitle of stack stackName into mTitles
   
   put line 1 of mTitles into mTitle
   put stackName & comma & "the menu_GlobalTitle of stack" into displayTitle
   display_Index mTitles, displayTitle, mTitle
end menu_TestMenu

on menu_StackProperties indexView
   put the selected_Index of indexView into stackName
   put the name of stack stackName into stackObject
   
   revIDEInspectObjects stackObject
end menu_StackProperties
         
on _
end _

on menu_DeleteController indexView
   put the title_Text of indexView into projectName
   put the selected_Index of indexView into stackName
   put the hilited_Lines of indexView into lineNum
   put the displayed_Index of indexView into stackNames
   put the fileName of stack stackName into controllerFile
   
   if controllerFile is empty then
      set the stackFile_RemovePaths of stack projectName to controllerFile
      put library_FetchProjectFolder (projectName) into projectFolder
      put project_ConstructFolder ("controllers", projectFolder) into controllerFolder
      
      put controllerFolder & stackName & "livecodescript" into controllerFile
      breakpoint
      exit to top
   end if
   
   set the itemdelimiter to slash
   put item -1 of controllerFile into shortControllerFile
   answer warning merge ("Are you sure you want to delete the controler [[shortControllerFile]]?") with "OK" or "Cancel"
   if it is "Cancel" then exit to top
   
   set the stackFile_RemovePaths of stack projectName to controllerFile
   delete stack stackName
   
   delete line lineNum of stackNames
   set the displayed_Index of indexView to stackNames
   
   delete file controllerFile
end menu_DeleteController

on menu_RevealFolder indexView
   put the title_Text of indexView into projectName
   put library_FetchProjectFolder (projectName) into projectFolder
   put project_ConstructFolder ("controllers", projectFolder) into controllerFolder
   finder_Reveal controllerFolder
end menu_RevealFolder

on menu_MoveStack indexView, newProjectName
   put the selected_Index of indexView into stackName
   put the name of stack stackName into stackObject
   
   put the project_Name of stackObject into oProjectName
   if oProjectName = newProjectName then
      answer warning merge ("Stack is already in project '[[newProjectName]]'. Choose a new project to move this library to!")
      exit to top
   end if
   
   put the short name of stackObject into stackName
   project_MoveLibrary stackName, newProjectName
   
   display_ProjectControllers newProjectName, indexView
end menu_MoveStack


--> Global | Controllers | Tree | Line | Menu | Props
-
getprop new_ProjectName [indexView]
   put the selected_Index of indexView into stackName
   put the project_Name of stack stackName into projectName
   return projectName
end new_ProjectName

getprop new_ProjectNames
   return library_ListProjectNames()
end new_ProjectNames

