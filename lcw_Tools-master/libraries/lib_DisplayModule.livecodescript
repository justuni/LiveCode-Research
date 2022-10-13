script "lib_DisplayModule"
--> MetaData
-
license: GPLv3
name: lib_DisplayModule
type: library
version: 0.1


--> Display | Module
-
command display_ModuleFromName moduleName, projectName
   put module_ViewNameToShortFolder (moduleName) into moduleFolderName 
   put library_FetchProjectFolder (projectName) into projectFolder
   put module_GetFolder (moduleFolderName, projectFolder) into moduleFolder
   
   display_Module moduleFolder
end display_ModuleFromName

command display_Module moduleFolder
   put project_ConstructHomeStackPath (moduleFolder) into moduleHomeStackPath
   if moduleHomeStackPath is empty then
      put moduleFolder
      answer warning "Cannnot locate a module in this folder!"
      exit to top
   end if
   
   set the itemdelimiter to slash
   put project_GetHomeStackName (moduleFolder) into moduleFolderName
   put item 1 to -3 of moduleFolder & slash into projectFolder
   put project_GetHomeStackName (projectFolder) into projectName
   put merge ("[[moduleFolderName]],[[projectName]] Module") into someTitle
   
   go to stack moduleHomeStackPath
   
   if exists (control 1 of cd 1 of stack moduleHomeStackPath) is true then
      put the long id of control 1 of cd 1 of stack moduleHomeStackPath into displayedObject
      if the view_Name of displayedObject is empty then
         put false into isaView
         put "Not a view" into viewProps
         put the name of stack moduleHomeStackPath into viewObject
      else
         put true into isaView
         put the view_Props of displayedObject into viewProps
      end if
   else
      -- the stack exists but there is no viewObject
      put false into isaView
      put the long id of cd 1 of stack moduleHomeStackPath into displayedObject
      put empty into viewProps
      put the short name of stack moduleHomeStackPath into viewTitle
   end if
   
   put view_ConstructToolMenu (displayedObject, isaView) into mTitles
   put line 1 of mTitles into mTitle
   if menu_Exists (mTitle) is false then
      put "Global | Module | Tree | Menu" into mTitle
   end if
   put "Global | Module | Tree | Line | Menu" into mLineTitle
   put empty into mUp
   
   display_Index viewProps, someTitle, mTitles, mLineTitle, mUp, "mDouble_EditProp"
   put the result into indexView
   set the multiple_Hilites of indexView to false
   
   set the displayed_Object of indexView to displayedObject
   set the displayed_ModuleFolder of indexView to moduleFolder
   set the displayed_ModuleName of indexView to moduleFolderName
   set the displayed_ModuleHomeStackPath of indexView to moduleHomeStackPath
   
   set the displayed_ProjectName of indexView to projectName
   set the displayed_ProjectFolder of indexView to projectFolder
   
   put the script of cd 1 of stack moduleHomeStackPath into cardScript
   if cardScript is not empty then
      edit the script of cd 1 of stack moduleHomeStackPath
   end if
   module_EditToolScripts moduleHomeStackPath, projectName
end display_Module


--> Display | Modules
-
command display_ActiveModules pIndexView
   put env_ListModuleHomeStackNames() into activeModuleHomeStackNames
   
   put "Active Modules,Environment" into stackTitle
   put "mDouble_DisplayModule" into mDoubleUp  
   
   put empty into mUp
   put "Global | Environment | Menu" into mTitle
   put "Global | Project | Tree | Line | Menu" into mLineTitle
   
   if exists (pIndexView) is false then
      display_Index activeModuleHomeStackNames, stackTitle, mTitle, mLineTitle, mUp, mDoubleUp
      put the result into displayView
      return displayView
   else
      lock screen
      set the view_Index of pIndexView to activeModuleHomeStackNames
      set the stack_Title of pIndexView to stackTitle
      set the mouse_DoubleUpEvent of pIndexView to mDoubleUp
      set the title_Menu of pIndexView to mTitle
      set the line_Menu of pIndexView to mLineTitle
      unlock screen
      return pIndexView
   end if
end display_ActiveModules


--> Display | Events
-
on mDouble_DisplayModule indexView, moduleStackName
   if exists (stack moduleStackName) is false then
      answer merge("Could not find stack '[[moduleStackName]]'.")
      exit to top
   end if
   
   put the module_Folder of stack moduleStackName into moduleFolder
   display_Module moduleFolder
end mDouble_DisplayModule

on mDouble_EditProp indexView, hName
   -- put the title_Text of indexView into moduleFolderName
   put the displayed_Object of indexView into viewObject
   put the behavior of viewObject into viewBehavior
   
   -- put revRuggedID (hObject) into hObject
   put "G" && hName into shortHkeyLine
   put hKeyLine_Construct (shortHkeyLine, viewBehavior) into hkeyLine
   
   hkey_Edit hkeyLine
end mDouble_EditProp


--> Display | Project | Modules
-
command display_ProjectModules homeNameOrPath, pIndexView
   put the short name of stack homeNameOrPath into projectHomeStackName
   
   put project_ListModuleHomeStackNames (projectHomeStackName) into moduleStackNames
   
   put empty into mUp
   put "mDouble_DisplayModule" into mDoubleUp
   put "Modules" into stackTitle
   put projectHomeStackName & comma & stackTitle into someTitle
   
   put "Global | Modules | Tree | Menu" into mTitle
   put "Global | Modules | Tree | Line | Menu" into mLineTitle
   
   if exists (pIndexView) is false then
      display_Index moduleStackNames, someTitle,mTitle, mLineTitle, mUp, mDoubleUp
      put the result into pIndexView
      set the multiple_Hilites of pIndexView to false
   else
      lock screen
      set the view_Index of pIndexView to moduleStackNames
      set the stack_Title of pIndexView to someTitle
      set the mouse_DoubleUpEvent of pIndexView to mDoubleUp
      set the title_Menu of pIndexView to mTitle
      set the line_Menu of pIndexView to mLineTitle
      unlock screen
   end if
   
   put library_FetchProjectFolder (projectHomeStackName) into projectFolder
   set the displayed_ProjectFolder of pIndexView to projectFolder
   set the displayed_HomeStackName of pIndexView to projectHomeStackName
   return pIndexView
end display_ProjectModules


--> Deps
-
command module_EditToolScripts moduleName, projectName
   put library_FetchProjectFolder (projectName) into projectFolder
   put module_ListBehaviorStackNames (moduleName, projectFolder) into behaviorStackNames
   repeat for each line behaviorStackName in behaviorStackNames
      edit the script of stack behaviorStackName
   end repeat
   put module_ListControllerStackNames (moduleName, projectFolder) into controllerStackNames
   repeat for each line controllerStackName in controllerStackNames
      edit the script of stack controllerStackName
   end repeat
end module_EditToolScripts
