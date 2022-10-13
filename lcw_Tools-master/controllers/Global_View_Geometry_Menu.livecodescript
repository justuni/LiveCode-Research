script "Global_View_Geometry_Menu"
--> MetaData
-
license: GPLv3
name: Global_View_Geometry_Menu
type: controller
version: 0.2


--> Global | View | Geometry | Menu
-
on menu_Clone mTarget
   put the stack_Name of mTarget into stackNameToClone
   stack_Clone stackNameToClone
end menu_Clone

on _
end _

on menu_DispatchLayoutControl viewObject
   put the card_Object of viewObject into cardObject
   put the view_RectOnCard of cardObject into cardRect
   
   if the shiftKey is "Down" then breakpoint
   dispatch "LayoutControl" to viewObject with cardRect
   switch it
      case "unhandled"
         -- breakpoint  
         lcw_Notify merge ("'Layoutcontrol' unhandled by view [[the name of viewObject]]!")
         
         put the behavior of viewObject into bObject
         if exists (bObject) then
            edit the script of bObject
         end if
         
         put the card_Object of viewObject into cardObject
         display_BrokenBehaviors cardObject, true
         break
      default
         lcw_Notify merge ("Dispatched 'Layoutcontrol' to view [[the name of viewObject]]!")
   end switch
end menu_DispatchLayoutControl

on menu_TestLayout someView
   put the card_Object of someView into cardControl
   put the view_RectOnCard of cardControl into cardRect
   
   repeat 6
      set the cursor to busy
      dispatch "LayoutControl" to someView with cardRect
   end repeat
   
   put merge ("Dispatched 'LayoutControl' to [[the name of someView]] 6 times") into someComment
   lcw_Notify someComment
end menu_TestLayout

on _
end _

on menu_DispatchResizeStack viewObject
   put the card_Object of viewObject into cardObject
   
   if the shiftKey is "Down" then breakpoint
   dispatch "resizeStack" to cardObject
end menu_DispatchResizeStack

on menu_DispatchResizeControl viewObject
   if the shiftKey is "Down" then breakpoint
   dispatch "resizeControl" to viewObject
end menu_DispatchResizeControl

on menu_DispatchPreopenCard viewObject
   if the shiftKey is "Down" then breakpoint
   dispatch "preOpenCard" to viewObject
end menu_DispatchPreopenCard

on menu_DispatchPreopenControl viewObject
   if the shiftKey is "Down" then breakpoint
   dispatch "preOpenControl" to viewObject
   switch it
      case "unhandled"
         put the card_Object of viewObject into cardObject
         display_BrokenBehaviors cardObject, true
         break
      default
         -- all is fine
   end switch
end menu_DispatchPreopenControl

on _
end _

on submenu_MoreTests
   return "Global | View | Test | Geometry | Menu"
end submenu_MoreTests


--> Global | View | Geometry | Menu | Props
-


--> Global | View | Geometry | Menu | Disabled
-
getprop disabled_DispatchResizeControl [viewObject]
   return the behavior_HandlerExists ["M resizeControl"] of viewObject is false
end disabled_DispatchResizeControl

getprop disabled_DispatchPreopenControl [viewObject]
   return the behavior_HandlerExists ["M preOpenControl"] of viewObject is false
end disabled_DispatchPreopenControl

getprop disabled_DispatchPreopenCard [viewObject]
   return the behavior_HandlerExists ["M preOpenCard"] of viewObject is false
end disabled_DispatchPreopenCard
