script "Global_View_Card_Create_Menu"
--> MetaData
-
license: GPLv3
name: Global_View_Card_Create_Menu
type: controller
version: 0.1


--> Global | View | Card | Create | Menu
-
on menu_CreateGroup cardObject
   put the stack_Name of cardObject into viewName
   go to stack viewName -- sets the topstack
   
   create group viewName
   put it into createdObject
   select createdObject
   choose pointer tool
   
   dispatch "resizeStack" to createdObject
   
   put metadata_ConstructUripArray (viewName, "view") into uripArray
   set the object_Metadata of createdObject to uripArray
   
   put the module_Behaviors of createdObject into moduleBehaviors
   set the behavior_Objects of createdObject to moduleBehaviors
   
   set the lockloc of createdObject to true
   set the showborder of createdObject to true
   object_Inspect createdObject
   edit the script of the behavior of createdObject
end menu_CreateGroup

on menu_MakeFirstControlAView firstControl
   put the stack_Name of firstControl into viewName
   put metadata_ConstructUripArray (viewName, "view") into uripArray
   set the object_Metadata of firstControl to uripArray
   
   set the name of firstControl to viewName
   put the module_Behaviors of firstControl into moduleBehaviors
   set the behavior_Objects of firstControl to moduleBehaviors
   
   object_Inspect firstControl
   edit the script of firstControl
end menu_MakeFirstControlAView

--> Global | View | Card | Create | Menu | Props
-

--> Global | View | Card | Create | Menu | Disabled
-
getprop disabled_MakeFirstControlAView [cardObject]
   if word 1 of cardObject = "card" then
      return true
   else
      return false
   end if
end disabled_MakeFirstControlAView

getprop disabled_CreateGroup [cardObject]
   if word 1 of cardObject = "group" then
      return "delete"
   else
      return false
   end if
end disabled_CreateGroup
