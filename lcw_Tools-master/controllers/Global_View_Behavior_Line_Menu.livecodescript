script "Global_View_Behavior_Line_Menu"
--> MetaData
-
license: GPLv3
name: Global_View_Behavior_Line_Menu
type: controller
version: 0.1

--> Variables
-
local LocalArray


--> Menu | Props
-
on menu_Init tObject
   put the index_View of tObject into indexView
   put indexView into LocalArray ["indexView"]
   
   -- put the title_Text of indexView into LocalArray ["moduleName"]
   put the view_Index of indexView into LocalArray ["bObjects"]
   put the selected_Line of indexView into LocalArray ["bObject"]
   put the hilited_Lines of indexView into LocalArray ["lineNum"]
   
   put the displayed_ProjectName of indexView into LocalArray ["projectName"]
   put the displayed_ProjectFolder of indexView into LocalArray ["projectFolder"]
   put the displayed_ModuleFolder of indexView into LocalArray ["moduleFolder"]
   put the displayed_ModuleName of indexView into LocalArray ["moduleName"]
   put the displayed_ModuleHomeStackPath of indexView into LocalArray ["moduleHomeStackPath"]   
end menu_Init


--> Global | View | Behavior | Line | Menu
-
on menu_SetViewBehavior moduleView
   put LocalArray ["bObject"] into bObject
   set the behavior of moduleView to bObject
end menu_SetViewBehavior

on _
end _

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Global | View | Behavior | Line | Menu | Props
-

--> Global | View | Behavior | Line | Menu | Disabled
-

--> Dev | Menu
-
on menu_MakeRed
   -- put LocalArray ["lineNum"] into lineNum
   put LocalArray ["indexView"] into indexView
   -- put the index_Field of indexView into fieldObject
   -- set the textcolor of line lineNum of fieldObject to "red"
   set the line_Colour of indexView to "red"
end menu_MakeRed
