script "Global_Index_Group_Menu"
--> MetaData
-
license: GPLv3
name: Global_Index_Group_Menu
type: controller
version: 0.1


--> Global | Index | Group | Menu
-
on menu_SetViewSpacing indexGroup
   put the view_Spacing of indexGroup into vSpacing
   put lcw_Ask ("What spacing do you want between views?", vSpacing) into vSpacing
   set the view_Spacing of indexGroup to vSpacing
end menu_SetViewSpacing

on menu_Views indexGroup, vName
   put the child_Views of indexGroup into childViews
   repeat for each line childView in childViews
      set the control_Type of childView to "placeholder"
   end repeat
end menu_Views

getprop v_Names
   return "placeholder"
end v_Names

on _
end _

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Global | Index | Group | Menu | Props
-

--> Global | Index | Group | Menu | Disabled
-


--> Dev | Menu
-
on menu_UpdateViews indexGroup
   put the child_Views of indexGroup into childViews
   repeat for each line childView in childViews
      view_Update childView
   end repeat
end menu_UpdateViews
