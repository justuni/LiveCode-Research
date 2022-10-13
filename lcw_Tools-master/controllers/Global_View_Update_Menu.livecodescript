script "Global_View_Update_Menu"
--> MetaData
-
license: GPLv3
name: Global_View_Update_Menu
type: controller
version: 0.1

--> Variables
-
local ViewIsObject, ViewIsOld


--> Global | View | Update | Menu
-
on menu_CreateNewComponent someView
   put the view_Name of someView into vName
   put library_AskNewViewName (vName) into vName
   
   library_CreateComponent vName, someView
   put the result into copiedView
   put the filename of stack vName into someFile
end menu_CreateNewComponent

on _
end _

on menu_Swap someView, vName
   put the mobile_Name of someView into mTarget
   set the view_Swap [false] of mTarget to vName
end menu_Swap

on menu_DisplayViewOutline someView
   put the view_NestedArray of someView into nestedViewArray
   put nestedViewArray ["viewOutline"] into viewOutline
   
   put the name of someView into someTitle
   put the title_Text of someView into projectName
   put comma & projectName after someTitle
   display_Lines viewOutline, someTitle, "mDoubleUp_View"
   put the result into displayView
   set the displayed_NestedViewArray of displayView to nestedViewArray
end menu_DisplayViewOutline

command mDoubleUp_View displayView, viewName
   get the clickLine
   put word 2 of it into lineNum
   put the displayed_NestedViewArray of displayView into nestedViewArray
   put nestedViewArray ["dictionary"] into viewDictionary
   put viewDictionary [lineNum] into metaDataArray
   put metaDataArray ["rObject"] into viewObject
   put metaDataArray ["view"] into viewName
   
   answer merge ("What would you like to do with the view '[[viewName]]'?") with "Cancel" or "Placeholder" or "Update"
   switch it
      case "Placeholder"
         set the control_Type of viewObject to "placeholder"
         break
      case "Update"
         view_Update viewObject
         break
      default
         exit to top
   end switch
end mDoubleUp_View

on _
end _

on menu_GoAndCheckVersion mTarget
   view_CheckVersion mTarget
end menu_GoAndCheckVersion

on menu_UpdateLibraryView mTarget
   view_AskUpdate mTarget
end menu_UpdateLibraryView

on menu_UpdateToLibraryView mTarget
   view_AskUpdate mTarget
end menu_UpdateToLibraryView

-- on menu_ChildViewBehavior viewChildAlternative
menu_SetChoice viewChildAlternative, shortName, viewAlternative
put ChildViewArray [viewAlternative] into childView
put the behavior of childView into childViewBehavior
edit the script of childViewBehavior
end menu_ChildViewBehavior

--on menu_SwapChildView viewChildAlternative
menu_SetChoice viewChildAlternative, shortName, viewAlternative
put ChildViewArray [viewAlternative] into childView
set the view_Swap [false] of childView to viewAlternative
end menu_SwapChildView

on _
end _

on menu_DefaultBahaviorScript someView
   put the template_DefaultScript of someView
end menu_DefaultBahaviorScript

on _
end _

on submenu_Development
   return "Dev | Menu"
end submenu_Development


--> Dev | Menu
-
on menu_SaveAllViews
   put view_StackNames() into stackNames
   repeat for each line stackName in stackNames
      if there is a stack stackName then
         save stack stackName
      end if
   end repeat
end menu_SaveAllViews

on menu_TestViewToSwap mTarget
   display_ActiveMenuArray
   put the mobile_Name of mTarget into mTarget
   display_Lines mTarget, "mTarget"
end menu_TestViewToSwap

on menu_BehaviorsOfView mTarget
   put the object_Behaviors of mTarget
end menu_BehaviorsOfView


--> Global | View | Update | Menu | Props
-
getprop v_Name [mTarget]
   if exists(mTarget) is false then return true
   put the view_Name of mTarget into viewName
   set the itemdelimiter to "|"
   delete item 1 of viewName
   return viewName
end v_Name

getprop v_Names [mTarget]
   if exists(mTarget) is false then return true
   put the view_Alternatives of mTarget into viewPaths
   return viewPaths & ",-,Layouts|Placeholder"
end v_Names

getprop view_ChildAlternative [mTarget]
   put the view_Object of mTarget into someView
   if exists(someView) is false then return empty
   
   set the itemdelimiter to "|"
   repeat for each line childView in the view_Children of mTarget
      get the view_Name of childView
      delete item 1 of it
      put it  & CR after viewNames
   end repeat
   delete char -1 of viewNames
   return viewNames
end view_ChildAlternative

getprop view_ChildAlternatives [mTarget]
   put empty into ChildViewArray
   put the view_Object of mTarget into someView
   if exists(someView) is false then return empty
   
   repeat for each line childView in the view_Children of mTarget
      put the short name of childView & CR after someOutline
      get the view_Alternatives of childView
      repeat for each line viewAlternative in it
         put childView into ChildViewArray [viewAlternative]
      end repeat
      put outline_IncreaseIndent(it) & CR after someOutline
   end repeat
   return word 1 to -1 of someOutline
end view_ChildAlternatives


--> Dev | Menu | Disabled
-
getprop disabled_TestViewToSwap [mTarget]
   return _isNotTemplate (mTarget) is false
end disabled_TestViewToSwap

getprop disabled_BehaviorsOfView [mTarget]
   return _isNotTemplate (mTarget) is false
end disabled_BehaviorsOfView

getprop disabled_FixBrokenBehaviors [mTarget]
   return _isNotTemplate (mTarget) is false
end disabled_FixBrokenBehaviors


--> Global | View | Update | Menu | Disabled
-
-- getprop disabled_DisplayViewOutline [mTarget]
return _isNotTemplate (mTarget) is false
end disabled_DisplayViewOutline

getprop disabled_GoAndCheckVersion [mTarget]
   return _isNotTemplate (mTarget) is false
end disabled_GoAndCheckVersion

getprop disabled_Swap [mTarget]
   return _isNotTemplate (mTarget) is false
end disabled_Swap

getprop disabled_UpdateLibraryView [menuButtonObject]
   if _isNotTemplate (mTarget) is false then return true
   
    if the shiftkey is "Down" then return false
    put the displayed_View of me into targetObject
    if exists(displayedView) is false then
        return false
    else if the object_IsView of targetObject is false then
        return true
    else
        put targetObject into someView
        put the view_Template of someView into libraryView
        if libraryView is empty then
            return true
        else
            put the object_Version of someView into thisVersion
            put the object_Version of libraryView into libraryVersion
            if thisVersion = libraryVersion then
                return "Delete"
            else
                return false
            end if
        end if
    end if
end disabled_UpdateLibraryView

-- getprop disabled_View [mTarget]
    return exists(mTarget) is false
end disabled_View

-- getprop disabled_ViewOutline [mTarget]
   if the object_IsView of mTarget is true then
      return false
   else
      return "delete"
   end if
end disabled_ViewOutline

getprop disabled_ViewTools
   put menu_GetTarget("Global | Script | Editor | Menu") into someView
   if exists(someView) is false then 
      log_Error "menu_GetTarget('Global | Script | Editor | Menu') does not exist!", "disabled_ViewTools", true
      return true
   end if
   
   -- this happens before sending,
   -- and before constructing "menu_ViewTools" subMenu using "view_ToolMenus"
   -- so lets set the menuTarget!
   
   -- put "Global | Record | Menu" into viewsMenuTitles
   put the menu_ToolTitle of someView into viewsMenuTitle
   menu_SetTitleTargetOveride viewsMenuTitle, someView
   
   put the menu_ToolTitle of someView into mTitle
   put menu_GetGlobalController(mTitle) into viewToolControllerObject
   if exists(viewToolControllerObject) then
      return false
   else
      return "delete"
   end if
end disabled_ViewTools


--> Private
-
private function library_AskNewViewName vName
   put lcw_Ask ("Give the cloned view a name...", vName) into vName
   if exists (stack vName) then
      beep
      put merge ("The view '[[vName]]' already exists! Please manually delete the file or choose a new name.") into someWarning
      answer warning someWarning
      go to stack vName
      exit to top
   end if
   return vName
end library_AskNewViewName

private function _isNotTemplate viewObject
   -- this would disable the entire menu if the mTarget was not a view.
   put the view_Name of viewObject into vName
   if vName = empty then
      return false
   else
      -- disable if the viewObject is a template
      put the view_Template of viewObject into templateObject
      if templateObject = viewObject then
         return false
      else
         return true
      end if
   end if
end _isNotTemplate


--> Menu | Props
-
