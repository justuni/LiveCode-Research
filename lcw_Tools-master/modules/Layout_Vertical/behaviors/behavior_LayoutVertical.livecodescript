script "behavior_ViewLayoutVertical"
--> MetaData
-
license: GPLv3
name: behavior_ViewLayoutVertical
type: view behavior
version: 0.2

/*
See also "lib_ViewUpdate"
*/


--> Variables
-
local LocalArray


--> Work in Progress
-
setprop view_Insert viewNames
   replace comma with CR in viewNames
   lock screen
   repeat for each line viewName in viewNames
      put view_GetTemplateObject (viewName) into templateObject
      copy templateObject to me
      put it into createdObject
      put createdObject & CR after createdObjects
   end repeat
   LayoutControl
   unlock screen
   delete char -1 of createdObjects 
   return createdObjects
end view_Insert

getprop row_Number
   put the childControlIDs of me into someIDs
   put the number of lines of someIDs into numberOfRows
   return numberOfRows
end row_Number

setprop row_Number [cloneObject] rowNum
   lock screen
   put the childControlIDs of me into someIDs
   put the number of lines of someIDs into maxNum
   switch
      case rowNum > maxNum
         put line maxNum of someIDs into lastID
         if exists (cloneObject) is false then 
            put the long id of control id lastID into cloneObject
         end if
         repeat (rowNum - maxNum)
            -- clone only works if already in the group
            copy cloneObject to me
            put it into createdObject
         end repeat
         break
      case rowNum < maxNum
         put rowNum + 1 into toRowNum
         repeat with lineNum = maxNum down to toRowNum
            put line lineNum of someIDs into someID
            put the long id of control id someID into topObject
            delete topObject
         end repeat
         break
      default
         -- nothing to do
   end switch
   LayoutControl
   unlock screen
end row_Number


--> Layout
-
getprop layout_ViewNames
   put the childControlIDs of me into someIDs
   repeat for each line someID in someIDs
      put the long id of control id someID into topObject
      put the view_Name of topObject into vName
      if vName is not empty then
         put vName & CR after vNames
      end if
   end repeat
   delete last char of vNames
   return vNames
end layout_ViewNames

setprop layout_ViewNames vNames
   -- could be faster
   replace comma with CR in vNames
   lock screen
   set the row_Number of me to 0
   repeat for each line vName in vNames
      put view_GetTemplateObject (vName) into templateObject
      if exists (templateObject) is false then next repeat
      copy templateObject to me
   end repeat
   Layoutcontrol
   unlock screen
end layout_ViewNames


--> Objects
-
getprop layout_Object
   return the long id of me
end layout_Object

getprop view_Object
   return the long id of me
end view_Object


--> Events
-
on resizeControl pFirstparam
   put the rect of me into pRect
   LayoutControl pRect
end resizeControl


--> Geometry
-
on LayoutControl pRect
   lock screen
   if pRect is empty then put the rect of me into pRect
   put the margins of me into myMargins
   rect_SubtractMargins pRect, myMargins
   
   -- rect_CreateMask pRect, "Inner"
   
   put item 4 of pRect - item 2 of pRect into innerHeight
   
   put the childcontrolids of me into topControlIDs
   put the number of lines of topControlIDs into numberOfChildren
   if numberOfChildren = 0 then return 0
   
   put numberOfChildren - 1 into gutterNum
   put the view_Spacing of me into viewSpacing
   
   put item 2 of pRect into childTop
   repeat with cNum = 1 to numberOfChildren    
      put line cNum of topControlIDs into topControlID
      
      put the effective height of control id topControlID into someHeight
      put childTop + someHeight into childBottom
      
      put pRect into childRect
      put childTop into item 2 of childRect
      put childBottom into item 4 of childRect
      set the rect of control id topControlID to childRect
      
      -- rect_CreateMask childRect, ("Child" && topControlID)
      
      put childBottom + viewSpacing into childTop
   end repeat
   unlock screen
   return numberOfChildren
end LayoutControl

getprop view_Spacing
   put LocalArray ["viewSpacing"] into someNum
   if someNum is not a number then -- let's set a default
      put 8 into someNum
      put someNum into LocalArray ["viewSpacing"]
   end if
   return someNum
end view_Spacing

setprop view_Spacing someNum
   put someNum into LocalArray ["viewSpacing"]
   LayoutControl
end view_Spacing
