script "Global_Tree_With Title_Menu"
--> MetaData
-
license: GPLv3
name: Global_Tree_With Title_Menu
type: controllers
version: 0.2


--> Menu | Props
-

--> Global | Tree | With Title | Menu
-
on menu_TestView viewObject
   put the view_Name of viewObject
end menu_TestView

on _
end _

on menu_ReplaceTitle viewObject, whichTitle
   put the title_View of viewObject into titleView
   switch whichTitle
      case "Tree with title"
         set the control_Type of titleView to "View|Title|Tree"
         break
      case "Placeholder"
         set the control_Type of titleView to "placeholder"
         break
   end switch
end menu_ReplaceTitle


--> Tree | Menu | Props
-
getprop title_MenuItems [mTarget]
   put the title_View of mTarget into titleView
   put the view_PropertyMenu of titleView into someMenu
   return someMenu
end title_MenuItems

getprop field_MenuItems [mTarget]
   put the tree_Field of mTarget into treeField
   put the view_PropertyMenu of treeField into someMenu
   return someMenu
end field_MenuItems


--> Menu | Target
-
-- getprop menu_Target [mTitlePath]  
   put menu_GetTargetObject() into tObject
   switch
      case mTitlePath contains "Global | Title" 
         if word 1 of tObject = "card" then put the card_View ["Title|"] of tObject into tObject
         put the tree_View of tObject into treeView
         if exists(treeView) is false then pass menu_Target
         return the title_View of treeView
      case mTitlePath contains "Global | Tree | Line | Controller | Menu" or mTitlePath contains "Global | Tree | Field | Menu" or mTitlePath contains "Global | Tree | Toggle | Menu"
         if word 1 of tObject = "card" then put the card_View ["Tree|"] of tObject into tObject
         put the tree_View of tObject into treeView
         if exists(treeView) is false then pass menu_Target
         return the tree_Field of treeView
      case mTitlePath contains "Global | Tree | Menu"
         if word 1 of tObject = "card" then put the card_View ["Tree|"] of tObject into tObject
         put the tree_View of tObject into treeView
         return treeView
      default
         pass menu_Target
   end switch
end menu_Target

-- getprop menu_CheckTarget [mTarget]
   -- put the view_IsClass ["Tree|"] of mTarget into isTree
   put the tree_Field of mTarget into treeField
   return exists(treeField)
end menu_CheckTarget


--> Dev | Menu
-
on menu_TreeField mTarget, fieldMenuItem
   put the tree_Field of mTarget into treeField
   view_DoPropertyMenu fieldMenuItem, treeField 
end menu_TreeField

on menu_Title mTarget, titleMenuItem
   put the title_View of mTarget into titleView
   view_DoPropertyMenu titleMenuItem, titleView 
end menu_Title



