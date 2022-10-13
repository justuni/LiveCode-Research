script "lib_DragAndDrop"
--> MetaData
-
license: GPLv3
name: lib_DragAndDrop
type: library
version: 0.1


/*
The start of a library for all things drag and drop.

This library is a fairly crude hack that allow global drag and dropping onto any Livecode control.

See library script events of stack "libOPN_FrontScript":  "dragEnter" and "dragDrop"
They use "drag_GetGlobalStatus" and "drag_SetGlobalStatus"
*/


--> Working on
-
getprop locked_View
   put the view_Object of the target into targetView
   if exists(targetView) is false then return false
   
   repeat
      put the view_AboveTarget of the owner of targetView into viewAbove
      if exists(viewAbove) is false or word 1 of viewAbove = "card" then exit repeat
      if the selectGroupedControls of viewAbove is false then
         -- view above does not allow visible inner views
         put viewAbove into targetView
      else
         exit repeat
      end if
   end repeat
   return targetView
end locked_View


--> Events | Drag and Drop
-
on dragEnter
   if drag_GetGlobalStatus() is true then
      put the dragdestination into dropTarget
      put the dragsource into gDragSource
      switch
         case gDragSource = dropTarget
            set the dragAction to "none"
            break
         case the view_Name of dropTarget is empty and word 1 of the owner of dropTarget = "card"
            set the dragAction to "copy"
            break
         default
            -- it's a view
            set the dragAction to "link"
      end switch
   end if
   pass dragEnter
end dragEnter

on dragDrop
   -- just so we don't need to remember to do it in "dragEnd" handler  in the source
   drag_SetGlobalStatus false
   
   -- no passing prevents dropping of text into fields
   pass dragDrop
end dragDrop


--> Drag and Drop
-
on drag_SetGlobalStatus someBoolean
    global gLCW
    put someBoolean is true into gLCW ["Global_Drag"]
end drag_SetGlobalStatus

function drag_GetGlobalStatus
    global gLCW
    return gLCW ["Global_Drag"] is true 
end drag_GetGlobalStatus


--> Drag
-
setprop drag_Dropped
   -- a default value 
   -- put here to avoid setting custom properties of things that should not be touched
    -- put the params
end drag_Dropped

getprop dropped_TargetName
   put the long id of the target into targetObject
   put drag_GetDroppedTargetView (targetObject) into targetView
   return targetView
end dropped_TargetName

function drag_GetDroppedTargetView targetObject
   put the name of targetObject
   put the locked_View of targetObject into targetView
   if exists (targetView) is false then return false
   return targetView
end drag_GetDroppedTargetView
