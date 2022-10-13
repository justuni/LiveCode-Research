script "Global_Module_Tree_Menu"
--> MetaData
-
license: GPLv3
name: Global_Module_Tree_Menu
type: controllers
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


--> Global | Module | Tree | Menu
-
on menu_CreateStandAlone indexView
   put the view_Name of indexView into vName
   put view_GetTemplateObject (vName) into templateObject
   if exists (templateObject) is false then
      breakpoint
   end if
   
   put the stack_Name of templateObject into stackName
   clone stack stackName
   put it into clonedStack
   set the destroyStack of clonedStack to true
   set the destroyWindow of clonedStack to true
   
   put the long id of cd 1 of clonedStack into clonedTemplateCard
   put the long id of control 1 of clonedTemplateCard into clonedView
   
   -- put the module_Behaviors of viewObject into bObjects
   set the imported_ViewBehaviors of clonedView to true
   
   
   -- set the behavior of clonedTemplateCard to empty
   
   display_ViewBehaviors clonedView, empty, clonedStack
end menu_CreateStandAlone

command _importMenus viewObject
   put the module_Controllers of viewObject into cObjects
   repeat for each line cObject in cObjects
      if exists (cObject) is false then 
         breakpoint
         next repeat
      end if
      
      if word 1 of cObject is not "stack" then
         breakpoint
         next repeat
      end if
      
      put the stack_Name of cObject into cStackName
      put cStackName && "Dep"
      
      clone cObject
      put it into clonedBehaviorStack
      set the name of clonedBehaviorStack to newName
   end repeat
end _importMenus

on _
end _
   
on submenu_Module
   return "Global | Module | Menu"
end submenu_Module

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Dev | Menu
-
on menu_EditViewMenuFunction
   -- find the function that creates the menu table for the tree
   hkey_Edit "F view_ConstructToolMenu"
   -- put the name of stack "lib_DisplayView" into stackObject
   -- edit the script of stackObject
end menu_EditViewMenuFunction

on menu_ModuleInfo viewObject
   -- put menu_GetTargetObject() into tObject
   -- put the index_View of tObject into indexView
   put the module_Array of viewObject into moduleArray
   put moduleArray ["viewName"] into viewName
   put merge ("[[viewName]],Module Array") into someTitle
   display_Array moduleArray, someTitle
end menu_ModuleInfo

on menu_EditMenus
   menu_Edit "Global | View | Card | Tools | Menu"
   menu_Edit "Global | View | Card | Create | Menu"
end menu_EditMenus


-- > Global | Module | Tree | Menu | Props
-


--> Global | Module | Tree | Line | Menu
-
on menu_ViewProperty viewObject
   put menu_GetTargetObject() into tObject
   put the index_View of tObject into indexView
   
   put the displayed_Object of indexView into viewObject
   -- put the title_Text of indexView into moduleFolderName
   put the selected_Index of indexView into viewProp
   
   put the viewProp of viewObject
end menu_ViewProperty
