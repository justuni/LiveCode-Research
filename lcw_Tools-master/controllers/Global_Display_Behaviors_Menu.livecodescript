script "Global_Display_Behaviors_Menu"
--> MetaData
-
license: GPLv3
name: Global_Display_Behaviors_Menu
type: modules
version: 0.1


--> Menu | Props
-
on menu_Init tObject
   put the array_View of tObject into arrayView
   put arrayView into LocalArray ["arrayView"]
      
   put the displayed_ProjectName of arrayView into LocalArray ["projectName"]
   put the displayed_ProjectFolder of arrayView into LocalArray ["projectFolder"]
   put the displayed_ModuleFolder of arrayView into LocalArray ["moduleFolder"]
   put the displayed_ModuleName of arrayView into LocalArray ["moduleName"]
   put the displayed_ModuleHomeStackPath of arrayView into LocalArray ["moduleHomeStackPath"]   
end menu_Init


--> Global | Display | Behaviors | Menu
-
on menu_DisplayBehaviors treeView
   put the displayed_Object of treeView into cardObject
   put the stack_Object of treeView into stackObject
   put the label of stackObject
   -- put the title_text of treeView
end menu_DisplayBehaviors


--> Global | Display | Behaviors | Line | Menu
-
on menu_EditBrokenView treeView
   put the displayed_Object of treeView into cardObject
   display_Module moduleFolder
end menu_EditBrokenView

on menu_FixBrokenBehavior someView
   breakpoint
   _SetModuleFolder treeView, someView, moduleStackName, moduleFolder
   
   put the module_Behaviors of stack moduleStackName into moduleBehaviors
   set the behavior_Objects of someView to moduleBehaviors
end menu_FixBrokenBehavior

on _
end _

on menu_DisplayValue someView
   put the module_Array of someView into moduleArray
   
   put the parent_Array of treeView into parentArray
   put the selected_Value of treeView into someValue
   put the hilited_Element of treeView
   
   -- put the parent_Array of treeView into parentArray
   -- put the hilited_Element of treeView into hilitedElement
   -- put item -1 of hilitedElement into brokenBehavior
end menu_DisplayValue


--> Private
-
private command _SetModuleFolder treeView, @someView, @moduleStackName, @moduleFolder
   breakpoint
   put the displayed_Object of treeView into cardObject
   put the selected_Value of treeView into shortObject
   
   put shortObject && "of" && cardObject into someView -- hack
   put the long id of of treeView into someView
   put revRuggedID (someView) into someView
   
   put the view_Name of someView into moduleStackName
   if exists (stack moduleStackName) is false then
      breakpoint
      return empty
   end if
   put the module_Folder of stack moduleStackName into moduleFolder
   return moduleFolder
end _SetModuleFolder
