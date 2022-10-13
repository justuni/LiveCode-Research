script "lib_DisplayControllers"
--> MetaData
-
license: GPLv3
name: lib_DisplayControllers
type: library
version: 0.1


--> Display | Events
-
command mDouble_DisplayStack indexView, stackName
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


--> Display | Project | Controllers
-
command display_ProjectControllers homeStackName, pIndexView
   put project_ListControllerPaths (homeStackName) into controllerPaths
   put stack_PathsToNames (controllerPaths) into stackNames
   
   put empty into mUp
   put "mDouble_DisplayStack" into mDoubleUp
   put merge ("[[homeStackName]],Project Controllers") into someTitle
   put "Global | Controllers | Tree | Menu" into mTitle
   put "Global | Controllers | Tree | Line | Menu" into mLineTitle
   put empty into pDragCommand
   
   if exists (pIndexView) is false then
      display_Index stackNames, someTitle, mTitle, mLineTitle, mUp, mDoubleUp, pDragCommand, true
      put the result into displayView
      return displayView
   else
      lock screen
      set the view_Index of pIndexView to stackNames
      set the stack_Title of pIndexView to someTitle
      set the mouse_DoubleUpEvent of pIndexView to mDoubleUp
      set the title_Menu of pIndexView to mTitle
      set the line_Menu of pIndexView to mLineTitle
      unlock screen
      return pIndexView
   end if
end display_ProjectControllers

command display_Controllers pIndexView
   put env_ListControllerStackNames() into activeControllerStackNames
   
   put empty into mUp
   put "mDouble_DisplayStack" into mDoubleUp
   put "Active Controllers,Environment" into stackTitle
   
   put "Global | Environment | Menu" into mTitle
   put "Global | Project | Tree | Line | Menu" into mLineTitle
   
   if exists (pIndexView) is false then
      display_Index activeControllerStackNames, stackTitle, mTitle, mLineTitle, mUp, mDoubleUp
      put the result into displayView
      return displayView
   else
      lock screen
      set the view_Index of pIndexView to activeControllerStackNames
      set the stack_Title of pIndexView to stackTitle
      set the mouse_DoubleUpEvent of pIndexView to mDoubleUp
      set the title_Menu of pIndexView to mTitle
      set the line_Menu of pIndexView to mLineTitle
      unlock screen
      return pIndexView
   end if
end display_Controllers
