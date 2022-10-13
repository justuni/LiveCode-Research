script "Global_Modules_Tree_Menu"
--> MetaData
-
license: GPLv3
name: Global_Modules_Tree_Menu
type: controller
version: 0.1


--> Menu | Props
-
getprop menu_Target
   put menu_GetTargetObject() into tObject
   put the index_View of tObject into indexView
   put the displayed_Object of indexView into viewObject
   return viewObject
   
   /*
   put the title_text of tObject into moduleStackName
   put module_NameToFolder (moduleStackName) into moduleFolderName 
   
   put the stack_Object of tObject into stackObject
   put the label of stackObject into projectName
   delete word -1 of projectName
   
   put module_GetHomeStackPath (moduleFolderName, projectName) into moduleHomeStackPath
   if exists (control 1 of cd 1 of stack moduleHomeStackPath) is false then
      breakpoint
      return empty
   end if
   put the long id of control 1 of cd 1 of stack moduleHomeStackPath into viewObject
   */
end menu_Target


--> Global | Modules | Tree | Menu
-
on menu_CreateModule indexView
   put the title_Text of indexView into projectName
   
   put "Choose a name for your new module...." into someQuestion
   put the clipboarddata ["text"] into suggestedAnswer
   set the itemdelimiter to "|"
   if item 1 of suggestedAnswer is not "View" then
      put "View|Test" into suggestedAnswer
   end if
   put lcw_Ask (someQuestion, suggestedAnswer) into moduleStackName
   
   put project_GetFolder (projectName) into projectFolder
   put project_ConstructFolder ("modules", projectFolder) into rootModuleFolder
   project_CreateModule moduleStackName, rootModuleFolder
end menu_CreateModule

on menu_ExportMenusAndStackFiles indexView
   put the title_Text of indexView into projectName
   put library_FetchProjectFolder (projectName) into projectFolder
   put the view_Index of indexView into moduleNames
   repeat for each line moduleName in moduleNames
      put module_FolderNameFromTitle (moduleName) into moduleFolderName
      put module_GetFolder (moduleFolderName, projectFolder) into moduleFolder
      if there is a folder moduleFolder then
         project_ExportMenusAndStackFiles moduleFolder
      end if
   end repeat
end menu_ExportMenusAndStackFiles

on _
end _

on menu_Refresh indexView
   put the title_Text of indexView into projectHomeStackName
   display_ProjectModules projectHomeStackName, indexView
end menu_Refresh

on menu_CheckModules indexView
   put the title_Text of indexView into projectName
   put the view_Index of indexView into moduleNames
   
   repeat for each line moduleName in moduleNames
      put the long id of control 1 of cd 1 of stack moduleName into templateView
      dispatch "view_FixBehavior" to templateView with templateView
      go to stack moduleName
   end repeat
end menu_CheckModules

--> Global | Modules | Tree | Menu | Props
-

--> Global | Modules | Tree | Menu | Disabled
-
