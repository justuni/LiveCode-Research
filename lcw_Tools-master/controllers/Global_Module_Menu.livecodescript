script "Global_Module_Menu"
--> MetaData
-
license: GPLv3
name: Global_Module_Menu
type: controller
version: 0.2


--> Global | Module | Menu
-
on menu_EditMenu viewOrStack, menuStackName
   edit the script of stack menuStackName
end menu_EditMenu

on menu_CreateModuleMenu viewOrStack
   breakpoint
   if the view_Name of viewOrStack is not empty then
      -- put view_ConstructToolMenu (viewOrStack, true) into gMenuTitle
      put the view_MenuTitle [true] of viewOrStack into gMenuTitle
      put "What is the name of your global menu...." into someQuestion
      put lcw_Ask (someQuestion, gMenuTitle) into gMenuTitle
   else
      put the project_Name of viewOrStack into moduleStackName
      put _askMenuTitle (moduleStackName) into gMenuTitle
   end if
   
   put the module_Folder of viewOrStack into moduleFolder
   module_CreateMenu moduleFolder, gMenuTitle
   put the result into controllerStackObject
   edit the script of controllerStackObject
end menu_CreateModuleMenu

on menu_CreateModuleBehavior viewOrStack
   put the project_Name of viewOrStack into moduleStackName
   put project_DefaultBehaviorName (moduleStackName) into maybeBehaviorStackName
   put lcw_Ask ("What name would you like for this modules behavior?", maybeBehaviorStackName) into behaviorStackName
   
   breakpoint
   put the module_Folder of viewOrStack into moduleFolder
   module_CreateBehavior moduleFolder, behaviorStackName
   put the result into moduleBehaviorStackPath
   edit the script of stack moduleBehaviorStackPath
end menu_CreateModuleBehavior

on _
end _

on menu_RevealModuleFolder viewOrStack
   put the module_Folder of viewOrStack into moduleFolder
   finder_Reveal moduleFolder
end menu_RevealModuleFolder


--> Global | Module | Menu | Props
-
getprop menu_StackNames [someView]
   put the module_Controllers of someView into cObjects
   repeat for each line cObject in cObjects
      put the short name of cObject into cName
      put cName & CR after cNames 
   end repeat
   delete char -1 of cNames
   sort cNames
   return cNames
end menu_StackNames


--> Global | Module | Menu | Disabled
-
getprop disabled_EditMenu [someView]
   put the module_Controllers of someView into cObjects
   return cObjects is empty
end disabled_EditMenu


--> Deps
-
private function _askMenuTitle moduleStackName, projectName
   put line 1 of the clipboarddata ["text"] into maybeMenuTitle
   if word -1 of maybeMenuTitle = "Menu" then
      put maybeMenuTitle into suggestedAnswer
   else
      set the itemdelimiter to "_"
      put "Global |" && item -1 of moduleStackName && "| Menu" into gMenuTitle
      menu_NormalizeTitle gMenuTitle, true
   end if
   
   put "What is the name of your global menu...." into someQuestion
   put lcw_Ask (someQuestion, gMenuTitle) into gMenuTitle
   return gMenuTitle
end _askMenuTitle
