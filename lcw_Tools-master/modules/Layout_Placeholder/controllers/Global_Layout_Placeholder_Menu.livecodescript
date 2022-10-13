script "Global_Layouts_Placeholder_Menu"
--> MetaData
-
license: GPLv3
name: Global_Layouts_Placeholder_Menu
type: controller
version: 0.5



--> Menu | Props
-
/*
menu_Target is defined in the view. Can override by placing a getprop menu_Target handler here.
*/

local LocalArray

on menu_Init tObject
   local objectArray
   put the view_Hierarchy of tObject into objectIndex
   put object_NamesFromIndex (objectIndex, objectArray) into objectNames
   put objectNames into LocalArray ["objectNames"]
   put objectArray into LocalArray ["objectArray"]
end menu_Init

function view_GetIndexMenu pForceLoad
   global gLCW_Placeholder
   
   view_LoadBigIndex pForceLoad
   return gLCW_Placeholder ["viewIndexMenu"]
end view_GetIndexMenu

command view_LoadBigIndex pForceLoad
   global gLCW_Placeholder
   
   if pForceLoad is true or gLCW_Placeholder ["viewIndexMenu"] is empty then
      put view_PathIndex() into viewPaths
      replace ("View|") with empty in viewPaths
      get outline_FromPathIndex(viewPaths, "|")
      if it is empty then 
         put "Place Holder" into gLCW_Placeholder ["viewIndexMenu"]
      else
         put it & cr & "-" & cr & "Place Holder" into vMenu
      end if
      put vMenu into gLCW_Placeholder ["viewIndexMenu"]
   end if
end view_LoadBigIndex

getprop menu_CheckTarget [mTarget]
   get the placeHolder_Button of mTarget
   return exists (it)
end menu_CheckTarget


--> Global | Layout | Placeholder | Replace | Menu
-
on menu_ReplaceWithPlaceholder mTarget 
   put the short name of mTarget into oName
   set the control_Type [oName] of mTarget to "placeHolder"
   put the result into newView
end menu_ReplaceWithPlaceholder

on _
end _

on menu_ReplaceWithWidget targetObject, widgetName 
   set the header_Height of targetObject to 64
   set footer_Height of targetObject to 49
   set the control_Type of targetObject to widgetName
end menu_ReplaceWithWidget

on menu_ReplaceWithControl targetObject, revControlName 
   set the control_Type of targetObject to revControlName
end menu_ReplaceWithControl

on menu_ReplaceWithView mTarget, viewPathFragment 
   -- set the view_Swap [true] of mTarget to viewPathFragment
   set the control_Type of mTarget to viewPathFragment
end menu_ReplaceWithView


--> Global | Layout | Placeholder | Menu
-
on submenu_Replace
   return "Global | Layout | Placeholder | Replace | Menu"
end submenu_Replace

on menu_UpdatePlaceholder mTarget
   view_Update mTarget, true
end menu_UpdatePlaceholder

on menu_UpdateLayoutPlaceholders mTarget
   put the layout_View of mTarget into layoutView
   put the top_Controls of layoutView into topControls
   repeat for each line someControl in topControls
      put the view_Name of someControl into vName
      if vName = "View|Layout|Placeholder" then
         put the view_Colour of someControl into oColour
         view_Update someControl, true
         put the result into newView
         set the view_Colour of newView to "random"
      end if
   end repeat
end menu_UpdateLayoutPlaceholders

on menu_Owner mTarget, ownerMenuItem
   menu_SendMessage ownerMenuItem
end menu_Owner

on _
end _

on menu_DisplayDragWidgets
   put "Global | Layout | Placeholder | Replace | Menu" into mTitle
   put "Controls,Drag and Drop" into someTitle
   put empty into mLineTitle
   put empty into mUp
   put empty into mDoubleUp
   put "drag_Delete" into dCommand
   put "headerBar,navBar,segmented,browser,tree" into someIndex
   display_Index someIndex, someTitle, mTitle, mLineTitle, mUp, mDoubleUp, dCommand
end menu_DisplayDragWidgets

command drag_Delete placeholderView, someThing
   switch someThing
      default
         put someThing
         breakpoint
   end switch
   return "View|SivaSiva|Navigation|Bottom"
end drag_Delete

on menu_DeleteMe mTarget
   send "delete mTarget" to mTarget in 0 ticks
end menu_DeleteMe

on _
end _

on menu_ChangeName mTarget
   put the short name of mTarget into someValue
   ask "Change the name of this place holder?" with someValue
   if the result is "Cancel" then exit to top
   put it into newValue
   set the name of mTarget to newValue
end menu_ChangeName

on menu_ChangeLabel mTarget
   put the view_Label of mTarget into someValue
   
   ask "Change the label of this place holder?" with someValue
   if the result is "Cancel" then exit to top
   put it into newValue
   
   set the view_Label of mTarget to newValue
end menu_ChangeLabel

on menu_ChangeColour mTarget
   answer color
   if the result is "Cancel" then exit to top
   put it into newValue
   
   set the view_Colour of mTarget to newValue
end menu_ChangeColour

on menu_IsTransparent mTarget, someBoolean
   set the view_IsOpaque of mTarget to not someBoolean
end menu_IsTransparent

on _
end _

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Global | Layout | Placeholder | Menu | Props
-
getprop rev_ControlNames
   return "field,button,field,image,scrollbar,graphic,player"
end rev_ControlNames

getprop is_Transparent [mTarget]
   put the view_IsOpaque of mTarget into isOpaque
   return not isOpaque
end is_Transparent

getprop some_Views
   if LocalArray ["objectNames"] is empty then
      return "This menu script"
   else
      return it & CR & "-" & CR & "This menu script"
   end if
end some_Views

getprop view_PathFragments
   put the shiftKey is "Down" into forceUpdate
   put view_GetIndexMenu (forceUpdate) into viewMenu
   return viewMenu
end view_PathFragments


--> Global | Layout | Placeholder | Menu | Disabled
-
getprop disabled_UpdatePlaceholder
   put menu_GetTargetObject() into targetObject
   put the placeHolder_Button of targetObject into placeHolderView
   if exists(placeHolderView) then
      put the view_IsOld of placeHolderView into isOld
      -- put isOld
      return isOld is not true
   else
      return true
   end if
end disabled_UpdatePlaceholder

getprop disabled_UpdateElements [mTarget]
   put the layout_Elements of mTarget into layoutElements
   if layoutElements is empty then
      return true
   else
      return false
   end if
end disabled_UpdateElements

getprop disabled_Owner [mTarget]
   put the view_Object of the owner of mTarget into viewOwner
   if exists (viewOwner) is false then return empty   
   return false
end disabled_Owner

getprop owner_MenuItems [mTarget]
   put the view_Object of the owner of mTarget into viewOwner
   if exists (viewOwner) is false then return empty
   
   put menu_GetToolTitle (viewOwner) into ownerMenuTitle
   menu_SetTitleTargetOveride ownerMenuTitle, viewOwner
   put the view_ToolMenu of viewOwner into mText
   return mText
end owner_MenuItems


--> Dev | Menu
-
on menu_TestTarget mTarget
   put the name of mTarget
end menu_TestTarget

on menu_ChangeWidth mTarget
   put lcw_Ask ("Change the width of placeholder to...", the width of mTarget) into newWidth
   set the width of mTarget to newWidth
   dispatch "LayoutControl" to the owner of mTarget
end menu_ChangeWidth

on menu_GoToPlaceholderTemplate
   put view_GetTemplateObject ("Layouts|Placeholder") into templateObject
   object_GoTo templateObject
end menu_GoToPlaceholderTemplate

on menu_UpdateElements mTarget
   put the layout_Elements of mTarget into layoutElements
   repeat for each line someView in layoutElements
      view_Update someView, true
   end repeat
end menu_UpdateElements

on _
end _

on submenu_Placeholder
   return "Global | View | Property | Menu"
end submenu_Placeholder

on submenu_Script
   return "Global | View | Script | Menu"
end submenu_Script
