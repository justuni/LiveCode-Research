script "Global_Project_Stacks_Tree_Line_Menu"
--> MetaData
-
license: GPLv3
name: Global_Project_Stacks_Tree_Line_Menu
type: controller
version: 0.1


--> Global | Project | Stacks | Tree | Line | Menu
-
on menu_EditStackScript indexView
   put the selected_Index of indexView into stackName
   edit the script of stack stackName
end menu_EditStackScript
