script "Global_Project_Export_Menu"
--> MetaData
-
license: GPLv3
name: Global_Project_Export_Menu
type: controller
version: 0.1


--> Variables
-
local LocalArray

on menu_Init tObject
   put the tree_View of tObject into LocalArray ["tree_View"]
end menu_Init


--> Global | Project | Export | Menu
-
on menu_ExportScriptObject stackObject
   breakpoint
   put LocalArray ["tree_View"] into treeView
   
   put the displayed_Object of treeView into stackObject
   script_ExportHandlersAndCalls stackObject, true
end menu_ExportScriptObject

on menu_ExportAndIndexProject stackObject
   breakpoint
   put LocalArray ["tree_View"] into treeView
   
   put the stack_Object of treeView into stackObject
   put the label of stackObject into projectName
   
   env_ExportAndIndexProject projectName
   put the result into hkeyPlaceArray
   
   display_Array hkeyPlaceArray
end menu_ExportAndIndexProject

on _
end _

on menu_ExportMenusAndStackFiles
   env_ExportMenusAndStackFiles
end menu_ExportMenusAndStackFiles

on menu_ExportAndIndexHandlers
   env_ExportAndIndexProjects
   answer "Exported all stacks!"
end menu_ExportAndIndexHandlers
