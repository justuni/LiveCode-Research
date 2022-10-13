script "Global_View_Behavior_Menu"
--> MetaData
-
license: GPLv3
name: Global_View_Behavior_Menu
type: controller
version: 0.1

--> Variables
-
local LocalArray


--> Menu | Props
-
on menu_Init tObject
   put the index_View of tObject into indexView
   put indexView into LocalArray ["indexView"]
   
   -- put the title_Text of indexView into LocalArray ["moduleName"]
   put the view_Index of indexView into LocalArray ["bObjects"]
   
   put the displayed_ProjectName of indexView into LocalArray ["projectName"]
   put the displayed_ProjectFolder of indexView into LocalArray ["projectFolder"]
   put the displayed_ModuleFolder of indexView into LocalArray ["moduleFolder"]
   put the displayed_ModuleName of indexView into LocalArray ["moduleName"]
   put the displayed_ModuleHomeStackPath of indexView into LocalArray ["moduleHomeStackPath"]   
end menu_Init

private command _refresh viewObject
   put LocalArray ["indexView"] into indexView
   display_ViewBehaviors viewObject, indexView
end _refresh


--> Global | View | Behavior | Menu
-
on menu_SetModuleBehaviors viewObject, moduleBehavior
   breakpoint
end menu_SetModuleBehaviors

on menu_ChooseViewBehavior viewObject
   breakpoint
   put LocalArray ["moduleFolder"] into moduleFolder
   answer file "Select a behavior for this view..." with moduleFolder -- with type "LiveCode Stacks|rev|RSTK"
   if it is empty then exit to top
   put it into stackPath
   put the name of stack stackPath into bObject
   set the behavior of viewObject to bObject
   
   _refresh viewObject
end menu_ChooseViewBehavior

on menu_EditViewBehavior viewObject
   put the behavior of viewObject into bObject
   edit the script of bObject
end menu_EditViewBehavior

on _
end _

on menu_ImportScriptOnlyBehaviors viewObject, someBoolean
   set the imported_ViewBehaviors [true] of viewObject to someBoolean
end menu_ImportScriptOnlyBehaviors

on _
end _

on menu_DeleteBehaviorGroup viewObject
   view_DeleteBehaviorGroup viewObject
end menu_DeleteBehaviorGroup

on menu_DeleteBehaviorCard viewObject
   view_DeleteBehaviorCard viewObject
end menu_DeleteBehaviorCard

on _
end _

on menu_DisplayNestedViewArray viewObject
   display_NestedViewArray viewObject
end menu_DisplayNestedViewArray

on menu_MoveExternalBehaviors viewObject, moveWhere
   breakpoint
   put LocalArray ["projectName"] into thisProjectName
   put LocalArray ["bObjects"] into bObjects
   put LocalArray ["projectFolder"] into projectFolder
   put LocalArray ["moduleFolder"] into moduleFolder
   
   switch moveWhere
      case "project behavior"
         put project_ConstructFolder ("behaviors", projectFolder) into newBehaviorFolder
         break
      case "module behavior"
         put project_ConstructFolder ("behaviors", moduleFolder) into newBehaviorFolder
         break
   end switch
   folder_CreateNested newBehaviorFolder
   
   set the itemdelimiter to slash
   repeat for each line bObject in bObjects
      put the project_Name of bObject into otherProjectName
      if otherProjectName is not thisProjectName then
         put bObject & CR after externalBehaviors
         
         put the filename of bObject into oldBehaviorPath
         put item -1 of oldBehaviorPath into shortFile
         put newBehaviorFolder & shortFile into newBehaviorPath
         
         breakpoint
         project_MoveStack oldBehaviorPath, newBehaviorPath, true
      end if
   end repeat
   delete char -1 of externalBehaviors
   put externalBehaviors
end menu_MoveExternalBehaviors

on _
end _

on menu_ModuleBehaviorFolder viewObject
   put LocalArray ["moduleFolder"] into moduleFolder
   put project_ConstructFolder ("behaviors", moduleFolder) into moduleBehaviorFolder
   finder_Reveal moduleBehaviorFolder
end menu_ModuleBehaviorFolder

on menu_ModuleFolder viewObject
   put LocalArray ["moduleFolder"] into moduleFolder
   finder_Reveal moduleFolder
end menu_ModuleFolder

on menu_ProjectFolder viewObject
   put LocalArray ["projectFolder"] into projectFolder
   finder_Reveal projectFolder
end menu_ProjectFolder

on _
end _

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Global | View | Behavior | Menu | Props
-
getprop module_Behavior [viewObject]
   put the behavior_Objects of viewObject into bObjects
   return bObjects
end module_Behavior

getprop module_Behaviors [viewObject]
   --  put the module_Behaviors of templateView into moduleBehaviors
   put the module_Behaviors of viewObject into moduleBehaviors
   return moduleBehaviors
end module_Behaviors

getprop import_ScriptOnlyBehaviors [viewObject]
   put the imported_ViewBehaviors of viewObject into alreadyImported
   return alreadyImported
end import_ScriptOnlyBehaviors


--> Global | View | Behavior | Menu | Disabled
-
getprop disabled_EditViewBehavior [viewObject]
   put the behavior of viewObject into bObject
   if exists (bObject) then
      return false
   else
      return true
   end if
end disabled_EditViewBehavior

getprop disabled_DeleteBehaviorGroup [viewObject]
   put the view_BehaviorGroup of viewObject into viewBehaviorGroup
   if exists (viewBehaviorGroup) then
      return false
   else
      return true
   end if
end disabled_DeleteBehaviorGroup

getprop disabled_DeleteBehaviorCard [viewObject]
   put view_GetBehaviorCard (viewObject) into bCardObject
   if exists (bCardObject) then
      return false
   else
      return true
   end if
end disabled_DeleteBehaviorCard

getprop disabled_MoveExternalBehaviors [viewObject]
   put the module_ExternalBehaviors of viewObject into bObjects
   if bObjects is empty then
      return true
   else
      return false
   end if
end disabled_MoveExternalBehaviors

getprop disabled_ModuleBehaviorFolder [viewObject]
   put LocalArray ["moduleFolder"] into moduleFolder
   put project_ConstructFolder ("behaviors", moduleFolder) into moduleBehaviorFolder
   if there is a folder moduleBehaviorFolder then
      return false
   else
      return true
   end if
end disabled_ModuleBehaviorFolder

getprop disabled_ExportBehaviors [viewObject]
   put the imported_ViewBehaviors of viewObject into someBoolean
   if someBoolean is true then
      return false
   else
      return true
   end if
end disabled_ExportBehaviors

getprop disabled_ImportMobileBehavior [viewObject]
   put the card_Object of viewObject into viewCardObject
   
   put the behavior_Objects of viewCardObject into bObjects
   put the name of stack "behavior_ViewTemplateCard" into viewTemplateBehavior
   line_Delete viewTemplateBehavior, bObjects
   
   if bObjects is empty then
      return true
   else
      return false
   end if
end disabled_ImportMobileBehavior


--> Dev | Menu
-
on menu_Refresh viewObject
   _refresh viewObject
end menu_Refresh

on menu_AddViewBehavior viewObject
   breakpoint
   view_AddBehavior viewObject
end menu_AddViewBehavior

on _
end _

on menu_ResetViewBehavior viewObject
   put the behavior of viewObject into bStackObject
   set the behavior of viewObject to bStackObject
end menu_ResetViewBehavior

on menu_FixBrokenBehaviors viewObject, menuChoice
   switch menuChoice
      case "Fix broken behaviors"
         display_BrokenBehaviors viewObject, true
         return the result
      case "Fix view behaviors"
         put the behavior_Objects of mTarget into someObjects
         break
      case "Fix all view behavors"
         put view_WithBehaviorIndex() into someObjects
         break
   end switch
   
   repeat for each line someObject in someObjects
      set the cursor to busy
      set the behavior of someObject to the behavior of someObject
   end repeat
   put someObjects
end menu_FixBrokenBehaviors

on _
end _

/*
These look like an old way of using the cardscript for the view
Now we use "the imported_ViewBehaviors"
and store the behaviors in buttons in a group
*/

on menu_ConvertViewBehavior scriptObject
   breakpoint
   put "Choose a name for your script only menu stack...." into pQuestion
   put "Global_Example_Menu" into suggestedAnswer
   
   put the script of scriptObject into bScript
   lcw_CreateLibrary "controller", pQuestion, suggestedAnswer
end menu_ConvertViewBehavior

on menu_MobileBehavior viewObject, someBoolean
   breakpoint
   -- adds or removes
   _SetMobileCardBehavior viewObject, someBoolean
end menu_MobileBehavior

on menu_ImportMobileBehavior viewObject, someBoolean
   breakpoint
   -- should close or refresh the script editor tab
   put the card_Object of viewObject into viewCardObject
   
   if someBoolean is true then
      -- put the object_MetaData of viewCardObject into uRipArray
      put the view_Name of viewObject into vName
      put metadata_ConstructUripArray (vName, "card") into uRipArray
      
      -- should be empty
      put the script of viewCardObject into viewCardScript
      
      breakpoint
      
      set the view_StoredScript of viewCardObject to viewCardScript
      
      put the behavior_Objects of viewCardObject into bObjects
      put the name of stack "behavior_ViewTemplateCard" into viewTemplateBehavior
      line_Delete viewTemplateBehavior, bObjects
      
      repeat for each line bObject in bObjects
         put word 1 to -1 of the script of bObject into bScript
         put script_DeleteSuite ("Metadata", bScript) into someScript
         put word 1 to -1 of someScript & CR & CR after bScripts
      end repeat
      delete char -2 to -1 of bScripts
      
      breakpoint
      set the script of viewCardObject to bScripts
      set the object_MetaData of viewCardObject to uRipArray
      
      _SetMobileCardBehavior viewObject, false
   else
      breakpoint
      put the view_StoredScript of viewCardObject into viewCardScript
      set the script of viewCardObject to viewCardScript -- should be empty
      set the view_StoredScript of viewCardObject to empty
      
      _SetMobileCardBehavior viewObject, true
   end if
   edit the script of viewCardObject
end menu_ImportMobileBehavior

on menu_ImportViewBehavior viewObject, someBoolean
   breakpoint
   -- should close or refresh the script editor tab
   if someBoolean is true then
      put the object_MetaData of viewObject into uRipArray
      put the script of viewObject into viewScript
      set the view_StoredScript of viewObject to viewScript
      put the script of the behavior of viewObject into bScript
      set the script of viewObject to bScript
      set the object_MetaData of viewObject to uRipArray
   else
      put the view_StoredScript of viewObject into viewScript
      set the script of viewObject to viewScript
      set the view_StoredScript of viewObject to empty
   end if
   edit the script of viewObject
end menu_ImportViewBehavior

private command _SetMobileCardBehavior viewObject, someBoolean
   put the card_Object of viewObject into viewCardObject
   put the behavior_Objects of viewCardObject into bObjects
   put the name of stack "behavior_LayoutMobileOrientation" into mobileBehaviorObject
   if someBoolean is true then
      line_Add mobileBehaviorObject, bObjects
   else
      line_Delete mobileBehaviorObject, bObjects
   end if
   set the behavior_Objects of viewCardObject to bObjects
end _SetMobileCardBehavior


--> Dev | Menu | Props
-

--> Dev | Menu | Disabled
-
getprop disabled_AddViewBehavior [mTarget]
   if exists (the behavior of mTarget) then
      return "delete"
   else
      return false
   end if
end disabled_AddViewBehavior
