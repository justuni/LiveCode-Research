script "lib_ModuleAuthoring"
--> MetaData
-
license: GPLv3
name: lib_ModuleAuthoring
type: library
version: 0.3


--> Working on
-
--> Module | Behavior

command module_CreateBehavior moduleFolder, pBehaviorStackName, pBehaviorScript
   breakpoint
   if pBehaviorStackName is empty then
      set the itemdelimiter to slash
      put item -1 of moduleFolder into shortFolderName
      put project_DefaultBehaviorName (shortFolderName) into pBehaviorStackName
   end if
   project_CreateStack moduleFolder, pBehaviorStackName, "behaviors", "behavior", pBehaviorScript
   put the result into moduleBehaviorStackPath
   return moduleBehaviorStackPath
end module_CreateBehavior

command module_MoveBehavior moduleStackName, shortFolderName, moduleFolder
   put view_GetTemplateObject (moduleStackName) into templateView
   if exists (templateView) is false then
      answer warning "Cannot locate view!"
      breakpoint
      return empty
   end if
   
   put the behavior of templateView into bObject
   if exists (bObject) is false then
      answer "There is no behavior for this view. Would you like to create one?" with "Create" and "No"
      if it is "Create" then
         breakpoint
         module_CreateBehavior moduleFolder
         put the result into moduleBehaviorStackPath
         
         edit the script of stack moduleBehaviorStackPath
         breakpoint
         return moduleBehaviorStackPath
      else
         return empty
      end if
   end if
   
   if word 1 of bObject is "stack" then
      put the filename of bObject into oldBehaviorStackPath 
      set the itemdelimiter to slash
      put item -1 of oldBehaviorStackPath into shortFile
      put module_ConstructBehaviorPath (moduleStackName, moduleFolder, shortFile) into moduleBehaviorStackPath
      project_MoveStack oldBehaviorStackPath, moduleBehaviorStackPath
      return moduleBehaviorStackPath
   else
      answer warning "Behavior is not a stack. Move manually!"
      put the script of bObject into bScript
      module_CreateBehavior moduleFolder, empty, bScript
      put the result into moduleBehaviorStackPath
      
      put the module_Behaviors of templateView into moduleBehaviors
      set the behavior_Objects of templateView to moduleBehaviors
      
      answer warning "Check new module behavior scriptonly stack. Then remove old button behavior?"
      edit the script of bObject
      edit the script of stack moduleBehaviorStackPath
      return moduleBehaviorStackPath
   end if
end module_MoveBehavior

function module_ConstructBehaviorPath moduleName, moduleFolder, pShortFile
   if pShortFile is empty then
      put module_ConstructBehaviorShortFile (moduleName) into pShortFile
   end if
   put project_ConstructFolder ("behaviors", moduleFolder) into moduleControllerFolder
   put moduleControllerFolder & pShortFile into moduleControllerPath
   return moduleControllerPath
end module_ConstructBehaviorPath

function module_ConstructBehaviorShortFile moduleStackName
   breakpoint
   view_NormalizePiped moduleStackName -- just in case
   replace "|" with empty in moduleStackName
   put moduleStackName & ".livecodescript" into shortFile
   return shortFile
end module_ConstructBehaviorShortFile

function project_DefaultBehaviorName shortFolderName
   replace "_" with empty in shortFolderName
   put "behavior_" & shortFolderName into behaviorStackName
   return behaviorStackName
end project_DefaultBehaviorName

function module_GetBehaviorStackPath behaviorStackName, rootModuleFolder
   put behaviorStackName & ".livecodescript" into shortBehaviorPath
   put rootModuleFolder & "behaviors/" & shortBehaviorPath into moduleBehaviorStackPath
   return moduleBehaviorStackPath
end module_GetBehaviorStackPath

command module_SetCardBehavior moduleStackName
   -- lets name the views card for convenience
   put moduleStackName into shortViewName
   set the itemdelimiter to "|"
   if item 1 of shortViewName = "View" then delete item 1 of shortViewName
   set the name of card 1 of stack moduleStackName to shortViewName
   
   put the long id of stack "behavior_ViewTemplateCard" into cardViewBehavior
   set the behavior of card 1 of stack moduleStackName to cardViewBehavior
end module_SetCardBehavior


--> Module | Menu
-
/*
A lcw controller is also know less formally as a "menu".
*/

command module_CreateMenu moduleFolder, pGlobalMenuTitle, pControllerScript
   breakpoint
   folder_CreateNested moduleFolder
   project_CreateMenu moduleFolder, pGlobalMenuTitle, pControllerScript   
   put the result into controllerStackObject
   return controllerStackObject
end module_CreateMenu

command project_CreateMenu moduleOrProjectFolder, pGlobalMenuTitle, pControllerScript
   if there is not a folder moduleOrProjectFolder then
      put moduleOrProjectFolder
      answer warning "Project or module folder does not exists!"
      breakpoint
      exit to top
   end if
   
   if pGlobalMenuTitle is empty then
      set the itemdelimiter to slash
      put item -1 of moduleOrProjectFolder into stackName
      put module_ConstructGlobalMenuTitle (stackName) into pGlobalMenuTitle 
   end if
   put module_FolderNameFromTitle (pGlobalMenuTitle) into controllerStackName
   
   if pControllerScript is empty then
      put controller_ConstructMenuScript (pGlobalMenuTitle) into pControllerScript
   end if
   
   project_CreateStack moduleOrProjectFolder, controllerStackName, "controllers", "controller", pControllerScript
   put the result into controllerStackPath
   set the menu_Update of stack controllerStackPath to true
   put the name of stack controllerStackPath into controllerStackObject
   return controllerStackObject
end project_CreateMenu

function controller_ConstructMenuScript mTitle
   put scaffold_GetTemplate ("Default Menu Script") into menuScriptTemplate
   put merge (menuScriptTemplate) into controllerScript
   return controllerScript
end controller_ConstructMenuScript

command module_ReIndexMenus templateView
   local moduleMenuTitleArray
   put the module_Controllers of templateView into menuStackObjects
   repeat for each line menuStackObject in menuStackObjects
      set the menu_Update of menuStackObject to true -- false
      put the result into mTitleArray
      union moduleMenuTitleArray with mTitleArray recursively
   end repeat
   return moduleMenuTitleArray
end module_ReIndexMenus


--> Module | Create
-
command project_CreateView viewName, pViewFilePath
   template_StackAlreadyExists viewName
   -- project_CreateStack projectName, stackName, "modules"
   
   -- create the stack and set the basics
   create stack viewName
   set the destroystack of stack viewName to true
   set the destroywindow of stack viewName to true
   
   module_SetCardBehavior viewName
   
   put the width of viewTemplate into sWidth
   put the height of viewTemplate into sHeight
   stack_SetDimensions templateStackObject, sWidth, sHeight
   
   if pViewFilePath is not empty then
      set the fileName of stack viewName to pViewFilePath
      save stack viewName
      set the stack_IsKnown of stack viewName to true
   end if
end project_CreateView

command project_CreateModule moduleStackName, rootModuleFolder, pViewStackPath, pScript
   text_AddTrailing rootModuleFolder, slash
   if there is not a folder rootModuleFolder then
      answer warning "Modules folder does not exist!"
      breakpoint
      put rootModuleFolder
      exit to top
   end if
   
   put project_NameToShortFolder (moduleStackName) into shortFolderName
   put rootModuleFolder & shortFolderName & slash into moduleFolder
   
   switch
      case exists (stack pViewStackPath)
         -- let's move everything
         put project_ConstructStandardFile (moduleStackName, rootModuleFolder, shortFolderName, "livecode") into moduleHomeStackPath
         
         folder_CreateNested moduleFolder
         project_MoveStack pViewStackPath, moduleHomeStackPath
         
         project_CreateStandardFolders moduleFolder, "behaviors,controllers"
         module_SetCardBehavior moduleStackName
         module_MoveBehavior moduleStackName, shortFolderName, moduleFolder
         put the result into moduleBehaviorStackPath
         module_MoveController moduleStackName, moduleFolder
         put the result into moduleControllerStackPath
         break
      case pViewStackPath is not empty
         put pViewStackPath
         answer warning "Cannot locate view stack!"
         breakpoint
         exit to top
         break
      default
         -- projectFolder, pStackName, pShortFolder, pLibType, pScript, pNotScriptOnly
         put project_NameToShortFolder (moduleStackName) into shortFolder
         put "home" into pLibType
         project_CreateStack rootModuleFolder, moduleStackName, shortFolder, "home", pScript, true
         put the result into moduleHomeStackPath
         save stack moduleHomeStackPath
         
         project_CreateStandardFolders moduleFolder, "behaviors,controllers"
         
         module_SetCardBehavior moduleStackName
         module_CreateBehavior moduleFolder
         put the result into moduleBehaviorStackPath
         
         module_CreateMenu moduleFolder
         put the result into moduleControllerStackPath
   end switch
   
   edit the script of stack moduleHomeStackPath
   edit the script of stack moduleBehaviorStackPath
   edit the script of stack moduleControllerStackPath
end project_CreateModule

command module_MoveController moduleStackName, moduleFolder
   put module_ConstructGlobalMenuTitle (moduleStackName) into globalMenuTitle
   put menu_GetGlobalController (globalMenuTitle) into mController
   
   if exists (mController) then
      if word 1 of mController = "stack" then
         put the filename of mController into oldControllerStackPath
         set the itemdelimiter to slash
         put item -1 of oldControllerStackPath into pShortFile
         put module_ConstructControllerPath (moduleStackName, moduleFolder, pShortFile) into newModuleBehaviorStackPath
         project_MoveStack oldControllerStackPath, newModuleBehaviorStackPath
         return newModuleBehaviorStackPath
      else
         answer warning "Menu controller is not a stack.  Please move manually?"
         edit the script of mController
         breakpoint
         return empty
      end if
   else
      module_CreateMenu moduleFolder -- ,moduleStackName
      put the result into newModuleBehaviorStackPath
      return newModuleBehaviorStackPath
   end if
end module_MoveController

function module_ConstructControllerPath moduleName, moduleFolder, pShortFile
   breakpoint
   if pShortFile is empty then
      put module_FolderNameFromTitle (moduleName) & ".livecodescript" into pShortFile
   end if
   put project_ConstructFolder ("controllers", moduleFolder) into moduleControllerFolder
   put pShortFile & pShortFile into moduleControllerPath
   return moduleControllerPath
end module_ConstructControllerPath

function module_GetControllerStackPath controllerStackName, rootModuleFolder
   put controllerStackName & ".livecodescript" into shortControllerPath
   put rootModuleFolder & "controllers/" & shortControllerPath into moduleControllerStackPath
   return moduleControllerStackPath
end module_GetControllerStackPath
