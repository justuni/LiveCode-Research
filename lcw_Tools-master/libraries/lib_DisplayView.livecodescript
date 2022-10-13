script "lib_DisplayView"
--> MetaData
-
license: GPLv3
name: lib_DisplayView
type: library
version: 0.3


--> Working on
-

--> Display | Events
-
on mDouble_DisplayStack indexView, stackName
   switch
      case exists (stack stackName) is false
         answer merge("Could not find stack '[[stackName]]'.")
         break
      case the scriptonly of stack stackName is true
         edit the script of stack stackName
         break
      default
         go to stack stackName
   end switch
end mDouble_DisplayStack


--> Display | Project | Views
-
command display_View viewName
   put view_GetTemplateObject (viewName) into viewTemplate
   object_GoTo viewTemplate
end display_View

command display_ViewIndex viewObject, pIndexView
   put the view_Props of viewObject into viewProps
   
   put the view_Name of viewObject into viewName
   put the module_Name of viewObject into moduleName
   put the project_Name of viewObject into projectName
   
   put viewName & comma & projectName into stackTitle
   
   put view_ConstructToolMenu (viewObject, true) into mTitle  
   put "Global | Module | Tree | Line | Menu" into mLineTitle
   put empty into mUp
   put "mDouble_EditProp" into mDoubleUp
   put empty into pDragCommand
   
   if exists (pIndexView) is false then
      display_Index viewProps, stackTitle, mTitle, mLineTitle, mUp, mDoubleUp, pDragCommand, true
      put the result into indexView
      set the multiple_Hilites of indexView to false
   else
      lock screen
      set the view_Index of pIndexView to viewProps
      set the stack_Title of pIndexView to stackTitle
      set the mouse_DoubleUpEvent of pIndexView to mDoubleUp
      set the title_Menu of pIndexView to mTitle
      set the line_Menu of pIndexView to mLineTitle
      unlock screen
      return pIndexView
   end if
   
   put the module_Folder of viewObject into moduleFolder
   put project_ConstructHomeStackPath (moduleFolder) into moduleHomeStackPath
   put the project_Folder of viewObject into projectFolder
   put the project_Name of viewObject into projectName
   
   set the displayed_Object of indexView to viewObject
   set the displayed_ViewName of indexView to viewName
   set the displayed_ModuleFolder of indexView to moduleFolder
   set the displayed_ModuleName of indexView to moduleFolderName
   set the displayed_ModuleHomeStackPath of indexView to moduleHomeStackPath
   set the displayed_ProjectName of indexView to projectName
   set the displayed_ProjectFolder of indexView to projectFolder
   return indexView
end display_ViewIndex

command display_ViewBehaviors viewObject, pIndexView, pStacklabel
   put the view_Behaviors of viewObject into bObjects
   put the view_Name of viewObject into viewName
   
   put the project_Folder of viewObject into projectFolder
   if projectFolder is empty then
      -- may not be in a module or project
      put viewName & comma & "No Project" into stackTitle
   else
      put the project_Name of viewObject into projectName
      put the module_Folder of viewObject into moduleFolder
      put the module_Name of viewObject into moduleName
      put project_ConstructHomeStackPath (moduleFolder) into moduleHomeStackPath
      
      put viewName & comma & projectName into stackTitle
   end if
   
   if exists (pIndexView) then
      set the view_Index of pIndexView to bObjects
      put pIndexView into indexView
   else
      display_Lines bObjects, stackTitle, "mDoubleUp_EditBehavior", moduleName, pStacklabel
      put the result into indexView
      set the title_Menu of indexView to "Global | View | Behavior | Menu"
      set the line_Menu of indexView to "Global | View | Behavior | Line | Menu"
   end if
   
   set the displayed_Object of indexView to viewObject
   set the displayed_ViewName of indexView to viewName
   
   if projectFolder is not empty then
      set the displayed_ModuleFolder of indexView to moduleFolder
      set the displayed_ModuleName of indexView to moduleFolderName
      set the displayed_ModuleHomeStackPath of indexView to moduleHomeStackPath
      set the displayed_ProjectName of indexView to projectName
      set the displayed_ProjectFolder of indexView to projectFolder
   end if
   
   -- now let's colour the behavior lines
   put moduleName into thisModuleName
   put projectName into thisProjectName
   put the behavior of viewObject into bObject
   
   repeat with lineNum =1 to the number of lines of bObjects
      put line lineNum of bObjects into cObject
      put exists (cObject) is false into notThere
      if notThere is true then
         switch
            case cObject = bObject
               set the line_Colour [lineNum] of indexView to "purple"
               break
            case notThere
               set the line_Colour [lineNum] of indexView to "red"
               break
         end switch
         next repeat
      end if
      
      put the project_Name of cObject into thatProjectName
      put thisProjectName is not thatProjectName into inAnotherProject
      switch
         case cObject = bObject and inAnotherProject
            set the line_Colour [lineNum] of indexView to "dark blue"
            break
         case cObject = bObject
            set the line_Colour [lineNum] of indexView to "green"
            break
         case inAnotherProject
            set the line_Colour [lineNum] of indexView to "orange"
            break
         default
            -- it's within the project so leave as deafult (black) colour
      end switch
   end repeat
   
   return indexView
end display_ViewBehaviors

command mDoubleUp_EditBehavior indexView, bObject
   put the displayed_Object of indexView into viewObject
   
   put the textcolor of the clickLine into lineColour
   switch lineColour
      case "255,0,0" -- red
         -- behavior is missing
         breakpoint
         break
      case "142,53,239" -- purple
         -- default behavior is missing
         breakpoint
         break
      case "0,255,0" -- green
         -- default behavior in this project
         edit the script of bObject
         break
      case "248,122,23" -- orange
         -- inAnotherProject
         _askMoveBehavior "Do you want to import this behavior from project '[[otherProjectName]]'?", bObject, viewObject
         display_ViewBehaviors viewObject, indexView
         break
      case "0,0,139" -- dark blue
         -- default behavior is in another project
         _askMoveBehavior "Do you want to import this default behavior from project '[[otherProjectName]]'?", bObject, viewObject
         set the behavior of viewObject to the behavior of viewObject -- probably not necessary?
         display_ViewBehaviors viewObject, indexView
         break
      default
         -- subview in this project
         edit the script of bObject
         -- put lineColour
   end switch
end mDoubleUp_EditBehavior

private command _askMoveBehavior someComment, bObject, viewObject
   put the project_Name of bObject into otherProjectName
   put merge (someComment) into someComment
   replace "'" with quote in someComment
   answer someComment with "Cancel" or "Copy" or "Move"
   switch it
      case "Copy"
         breakpoint
         break
      case "Move"
         if word 1 of bObject is not "stack" then
            breakpoint
            exit to top
         end if
         
         answer "Do you want to move the behavior to the behavior folder in the module_Folder or the project_Folder?" with "Cancel" or "Project" or "Module"   
         switch it
            case "Cancel"
               exit to top
            case "Project"
               put the project_Folder of viewObject into projectFolder
               put project_ConstructFolder ("behaviors", projectFolder) into newBehaviorFolder
               break
            case "Module"
               put the module_Folder of viewObject into moduleFolder
               put project_ConstructFolder ("behaviors", moduleFolder) into newBehaviorFolder
               break
         end switch
         folder_CreateNested newBehaviorFolder
         
         set the itemdelimiter to slash
         put the filename of bObject into oldBehaviorPath
         put item -1 of oldBehaviorPath into shortFile
         put newBehaviorFolder & shortFile into newBehaviorPath
         
         breakpoint
         project_MoveStack oldBehaviorPath, newBehaviorPath, true
         break
      default
         -- case "Cancel" 
         exit to top
   end switch
   
end _askMoveBehavior

command display_NestedViewArray viewObject
   put the view_NestedArray of viewObject into nestedViewArray
   
   put the view_Name of viewObject into viewName
   put the module_Name of viewObject into moduleName
   put the project_Name of viewObject into projectName
   
   put view_ConstructToolMenu (viewObject, true) into mTitle
   put viewName & comma & projectName into stackTitle
   
   display_Array nestedViewArray, stackTitle, mTitle
   put the result into arrayView
   
   set the displayed_Object of arrayView to viewObject
   set the displayed_ViewName of arrayView to viewName
   
   put the module_Folder of viewObject into moduleFolder
   put project_ConstructHomeStackPath (moduleFolder) into moduleHomeStackPath
   put the project_Folder of viewObject into projectFolder
   
   set the displayed_ModuleFolder of arrayView to moduleFolder
   set the displayed_ModuleName of arrayView to moduleFolderName
   set the displayed_ModuleHomeStackPath of arrayView to moduleHomeStackPath
   set the displayed_ProjectName of arrayView to projectName
   set the displayed_ProjectFolder of arrayView to projectFolder
   
   return arrayView
end display_NestedViewArray

command display_ProjectViews projectName
   put project_ListViewStackNames (projectName) into stackNames
   put merge ("[[projectName]],Views") into someTitle
   
   local mLineTitle, mUp
   display_Index stackNames, someTitle, "Global | Views | Tree | Menu", mLineTitle, mUp, "mDouble_DisplayStack"
   put the result into indexView
   set the multiple_Hilites of indexView to false
end display_ProjectViews

command display_ActiveViews pIndexView
   put env_ListViewStackNames() into activeViewStackNames
   
   put "Active Views,Environment" into stackTitle
   put "mDouble_DisplayStack" into mDoubleUp
   
   put empty into mUp
   put "Global | Environment | Menu" into mTitle
   put "Global | Project | Tree | Line | Menu" into mLineTitle
   
   if exists (pIndexView) is false then
      display_Index activeViewStackNames, stackTitle, mTitle, mLineTitle, mUp, mDoubleUp
      put the result into displayView
      return displayView
   else
      lock screen
      set the view_Index of pIndexView to activeViewStackNames
      set the stack_Title of pIndexView to stackTitle
      set the mouse_DoubleUpEvent of pIndexView to mDoubleUp
      set the title_Menu of pIndexView to mTitle
      set the line_Menu of pIndexView to mLineTitle
      unlock screen
      return pIndexView
   end if
end display_ActiveViews


--> Deps
-
function view_ConstructToolMenu viewObject, isaView
   put the view_MenuTitle [true] of viewObject into mTitle
   put CR & "-" after mTitle
   if isaView is not false then
      -- put CR & "Global | Module | Menu" & tab & "submenu" after mTitle
      put CR & "Global | Module | Tree | Menu" & tab & "submenu" & tab & "Module Tools" after mTitle
      put CR & "-" after mTitle
      put CR & "Global | View | Authoring | Menu" & tab & "submenu" after mTitle
      put CR & "Global | View | Script | Menu" & tab & "submenu" after mTitle
      put CR & "Global | View | Property | Menu" & tab & "submenu" after mTitle
      put CR & "Global | View | Geometry | Menu" & tab & "submenu" after mTitle
      -- put CR & "Global | Behavior | View | Menu" & tab & "submenu" after mTitle
      put CR &  "Global | View | Update | Menu" & tab & "submenu" after mTitle
   else
      put CR & "Global | Module | Menu" & tab & "submenu" after mTitle
   end if
   return mTitle
end view_ConstructToolMenu

