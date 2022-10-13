script "Global_Modules_Tree_Line_Menu"
--> MetaData
-
license: GPLv3
name: Global_Modules_Tree_Line_Menu
type: controllers
version: 0.1


--> Variables
-
local LocalArray


--> Menu | Props
-
on menu_Init tObject
   put the index_View of tObject into indexView
   put the selected_Index of indexView into moduleName
   put the displayed_HomeStackName of indexView into projectHomeStackName
   put the displayed_ProjectFolder of indexView into projectFolder
   put the project_Name of stack projectHomeStackName into projectName
   
   if exists (stack moduleName) is false then
      breakpoint
      return empty
   end if
   
   -- put module_FolderNameFromTitle (moduleName) into shortFolder
   -- put module_GetFolder (shortFolder, projectFolder) into moduleFolder
   put the stack_Folder of stack moduleName into moduleFolder
   put project_ConstructHomeStackPath (moduleFolder) into moduleHomeStackPath
   
   put indexView into LocalArray ["indexView"]
   put moduleFolder into LocalArray ["moduleFolder"]
   put moduleHomeStackPath into LocalArray ["moduleHomeStackPath"]
   put projectFolder into LocalArray ["projectFolder"]
   put projectName into LocalArray ["projectName"]
end menu_Init

getprop menu_Target
   put menu_GetTargetObject() into tObject
   put the selected_Index of tObject into moduleName
   return moduleName
end menu_Target

private command _refresh
   put LocalArray ["indexView"] into indexView
   put LocalArray ["projectName"] into projectName
   display_ProjectModules projectName, indexView
end _refresh


--> Global | Modules | Tree | Line | Menu
-
on menu_MoveModule moduleName, newProjectName
   put the stack_Folder of stack moduleName into oldModuleFolder
   put the project_Folder of stack moduleName into oldProjectFolder
   
   put module_ViewNameToShortFolder (moduleName) into moduleShortFolder
   -- put project_GetModuleFolder (moduleShortFolder, newProjectName) into newModuleFolder
   put library_FetchProjectFolder (newProjectName) into newProjectFolder
   put module_GetFolder (moduleShortFolder, newProjectFolder) into newModuleFolder
   
   revMoveFolder oldModuleFolder, newModuleFolder
   -- put the result
   
   -- we need to reload the stacks in the module ???
   -- not done yet
   
   -- and let's re-index them
   project_ExportMenusAndStackFiles oldProjectFolder
   project_ExportMenusAndStackFiles newProjectFolder
end menu_MoveModule

on menu_DeleteModule moduleName
   project_CloseAndDelete moduleName
   _refresh
end menu_DeleteModule

on _
end _

on menu_DisplayModule moduleName
   put LocalArray ["moduleFolder"] into moduleFolder
   display_Module moduleFolder
end menu_DisplayModule

on menu_RevealModuleFolder moduleName
   put LocalArray ["moduleFolder"] into moduleFolder
   if moduleFolder is empty then
      put the name of viewObject & CR & viewObject
      answer warning "Module folder is empty!"
      breakpoint
      exit to top
   end if
   
   finder_Reveal moduleFolder
end menu_RevealModuleFolder

on _
end _

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Global | Modules | Tree | Line | Menu | Props
-
getprop new_ProjectName [moduleName]
   put the project_Name of stack moduleName into projectName
   return projectName
end new_ProjectName

getprop new_ProjectNames
   return library_ListProjectNames()
end new_ProjectNames


--> Global | Modules | Tree | Line | Menu | Disabled
-
getprop disabled_AddModuleProject [moduleName]
   put the module_Folder of viewObject into moduleFolder
   put project_GetHomeStackName (moduleFolder) into moduleName
   put library_FetchProjectFolder (moduleName) into moduleFolder
   if there is a folder moduleFolder then return "delete"
   
   return false
end disabled_AddModuleProject


--> Dev | Menu
-
on menu_Refresh
   _refresh
end menu_Refresh

on menu_AddModuleProject moduleName
   put LocalArray ["moduleFolder"] into moduleFolder
   
   library_StoreProjectFolder moduleName, moduleFolder
   env_SetProjectFolder moduleName, moduleFolder
end menu_AddModuleProject
