script "Global_Script_Tree_Menu"
--> MetaData
-
license: GPLv3
name: Global_Script_Tree_Menu
type: controllers
version: 0.1


--> Global | Script | Tree | Menu
-
on menu_RevealStack indexView
   put the displayed_Object of indexView into hObject
   put the stack_Object of hObject into stackObject
   put the effective filename of stackObject into someFile
   finder_Reveal someFile
end menu_RevealStack

on _
end _

on insert_StackMenu
   return "Global | Stack | Menu"
end insert_StackMenu


--> Global | Script | Tree | Menu | Deps
-
--> Global | Script | Tree | Menu | Disabled
-


--> Global | Script | Tree | Line | Menu
-
on menu_EditHandler indexView
   put the selected_Index of indexView into shortHkey
   put the displayed_Object of indexView into hObject
   put hkeyline_Construct (shortHkey, hObject) into hkeyLine
   hkey_Edit hkeyLine
end menu_EditHandler
