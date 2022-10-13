script "Global_Environment_Menu"
--> MetaData
-
license: GPLv3
name: Global_Environment_Menu
type: controller
version: 0.6


--> Variables
-
local LocalArray


--> Events | Display
-
on doubleup_DisplayScriptOnlyfolder indexView, mainStackName
   -- put the data_Folder [true] of stack mainStackName into testDataFolder
   put textStack_ConstructDataFolder (mainStackName) into dataFolder
   put script_ReconstructFromExported (dataFolder) into someScript
   
   if exists (stack mainStackName) is false then
      create script only stack mainStackName
      set the script of stack mainStackName to someScript
      edit the script of stack mainStackName
      show stack mainStackName
   else
      display_Text someScript
      atom_DisplayText someScript
   end if
end doubleup_DisplayScriptOnlyfolder

function textStack_ConstructDataFolder mainStackName, pStackName, pLongObjectID
   -- same functionality as "getprop data_Folder"
   
   put textStack_ConstructFolder (mainStackName) into textStackFolder -- textStack_Folder
   put textStackFolder & "data/" into textStackDataFolder
   
   switch pStackName
      case empty
      case mainStackName
         put textStackDataFolder & "objects/" into dataFolder
         break
      default
         put textStackDataFolder & "objects/substacks/" & pStackName & "/" into dataFolder
   end switch
   
   switch word 1 of pLongObjectID
      case empty
      case "stack"
         put "stack/" after dataFolder
         break
      default
         put word 1 of pLongObjectID & "_" & word 3 of pLongObjectID & "/" after dataFolder
   end switch
   return dataFolder
end textStack_ConstructDataFolder


--> Global | Environment | Menu
-
on menu_DisplayRecentExports mTarget, howLong
   if howLong = "ask" then
      put lcw_Ask ("How many hours...", 60) into someHours
      if someHours is not a number then exit to top
      put someHours * 60 into howLong
   end if
   display_RecentExports howLong
end menu_DisplayRecentExports
   
on menu_Display indexView, displayWhat
   put displayWhat & comma & "Environment" into someTitle
   switch displayWhat
      case "List Projects"
         put library_ListProjectNames() into projectNames -- it's the default anyway
         display_ProjectList projectNames, indexView, someTitle
         break
      case "List Active Projects"
         if the shiftKey is "Down" then
            put env_ListProjects() into projectNames
         else
            put library_ListProjectNames() into projectNames
         end if
         display_ProjectList projectNames, indexView, someTitle
         break
      case "List All Projects"
         put library_ListProjectNames ("all") into projectNames -- it's the default anyway
         display_ProjectList projectNames, indexView, someTitle
         break
      case "List Projects and Modules"
         display_ProjectsAndModules
         break
      case "-"
      case "Libraries and Models"
         if the shiftKey is "Down" then
            display_LibrariesAndModels
         else
            display_LibrariesAndModels indexView
         end if
         break
      case "-"
      case "List All Modules"
         put library_ListProjectNames ("module") into projectNames
         set the view_Index [displayWhat] of indexView to projectNames
         set the mouse_DoubleUpEvent of indexView to "mDouble_DisplayModule"
         break
      case "Active Modules"
         if the shiftKey is "Down" then
            display_ActiveModules
         else
            display_ActiveModules indexView
         end if
         break
      case "-"
      case "Controllers"
         if the shiftKey is "Down" then
            display_Controllers
         else
            display_Controllers indexView
         end if
         break
      case "-"
      case "List All Behaviors"
         put env_ListBehaviorStackNames() into behaviorStackNames
         set the view_Index [displayWhat] of indexView to behaviorStackNames
         set the mouse_DoubleUpEvent of indexView to "mDouble_DisplayBehavior"
         break
      case "Behaviors"
         if the shiftKey is "Down" then
            display_ActiveBehaviors
         else
            display_ActiveBehaviors indexView
         end if
         break
      case "-"
         -- case "models"
      case "Views"
         if the shiftKey is "Down" then
            display_ActiveViews
         else
            display_ActiveViews indexView
         end if
         break
   end switch
end menu_Display

on _
end _

on menu_IndicateStarted
   display_ProjectList
end menu_IndicateStarted

on menu_SetMenu mTarget, mTitle
   ide_SetMenuTitle "Recent", mTitle
end menu_SetMenu

on menu_SetWatchMenu mTarget
   ide_SetScriptEditorTitles "Watch"
end menu_SetWatchMenu

on _
end _

on submenu_Project
   return "Global | Library | Project | Model | Menu"
end submenu_Project

on submenu_Create
   return "Global | ScriptEditor | Create | Menu"
end submenu_Create

on submenu_Export
   return "Global | Project | Export | Menu"
end submenu_Export

on _
end _

on submenu_Git
   return "Global | GIT | Menu"
end submenu_Git

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Global | Environment | Menu | Props
-
getprop m_Title
   return ide_ShortTitle ("Recent")
end m_Title

getprop m_Titles
   put ide_ListShortMenuTitles ("Recent") into shortNames
   return shortNames
end m_Titles

getprop how_Longs
   return "5 min,10 min,20 min,30 min,300 min,-,ask"
end how_Longs

getprop from_Whichs
   return "the used environment,-,the openstacks,the usedstacks"
end from_Whichs

getprop display_What [indexView]
   put the title_Text of indexView into someTitle
   return someTitle
end display_What

getprop display_Whats [indexView]
   return "List Projects,List Active Projects,List All Projects,List Projects and Modules,-,Libraries and Models,Libraries and Models,-,List All Modules,Active Modules,-,Controllers,List All Behaviors,Behaviors,Views"
end display_Whats

getprop active_Projects
   put env_ListProjects() into activeProjects
end active_Projects


--> Global | Environment | Menu | Disabled
-
getprop disabled_LoadStoredPlaceArray
   return LocalArray ["storedIsDifferent"] is false
end disabled_LoadStoredPlaceArray

getprop disabled_StoreActivePlaceArray
   return LocalArray ["storedIsDifferent"] is false
end disabled_StoreActivePlaceArray


--> Dev | Menu
-
on menu_WatchEditingScripts indexView, someBoolean
   if someBoolean is true then
      ide_AddRevEditScriptStack "LCW"
   else
      ide_RemoveRevEditScriptStack "LCW"
   end if
end menu_WatchEditingScripts

getprop watch_EditingScripts
   put ide_GetRevEditScriptStack ("LCW") into someBoolean
   return someBoolean
end watch_EditingScripts

on menu_LivecodePluginArray
   -- ide_AddRevEditScriptStack stackName
   -- this adds the stack stackname to the list of stacks that receive the "revEditScript" command
   -- send "revEditScript tObject" to this card of stack tPlugin
   global gREVMessageDispatch
   display_Array gREVMessageDispatch
end  menu_LivecodePluginArray

on _
end _

on menu_ShrinkStacks indexView, shrinkWhat
   switch shrinkWhat
      case "me"
         stack_Shrink indexView
         break
      case "display"
         put ide_VisibleStackNames ("display") into stackNames
         repeat for each line stackName in stackNames
            put the scaleFactor of stack stackName into someFactor
            if someFactor = 1 then
               put the name of stack stackName into stackObject
               stack_Shrink stackObject
            end if
         end repeat
         break
      case "shrink all"
         put ide_VisibleStackNames ()
         break
      case "-"
      case "restore"
         put ide_VisibleStackNames () into stackNames
         repeat for each line stackName in stackNames
            put the scaleFactor of stack stackName into someFactor
            if someFactor is not 1 then
               -- set the scaleFactor of stack stackName to 1
               put the name of stack stackName into stackObject
               stack_Shrink stackObject, 1
            end if
         end repeat
         break
   end switch
end menu_ShrinkStacks

on _
end _

on menu_LibraryProjectData
   put library_FetchProjectData() into libraryProjectData
   display_Array libraryProjectData, "library_FetchProjectData()", "Global | Library | Project | Model | Menu", "Global | Library | Project | Model | Line | Menu"
end menu_LibraryProjectData

on _
end _
 
on menu_RecreateScriptOnlyStack
   put lcw_UserMetadataFolder() into textStackRoot
   put folder_ListShort (textStackRoot) into exportedScriptOnlyStacks
   
   local mTitle, mLineTitle, mUp, mDoubleUp
   put "Script-only Stack Exports" into someTitle
   put "doubleup_DisplayScriptOnlyfolder" into mDoubleUp
   display_Index exportedScriptOnlyStacks, someTitle, mTitle, mLineTitle, mUp, mDoubleUp
   -- put the exported_Script of stack "LCW"
end menu_RecreateScriptOnlyStack

on _
end _

on submenu_ProjectTools
   return "Global | Project | Menu"
end submenu_ProjectTools

on submenu_Library
   return "Global | Library | Menu"
end submenu_Library

on submenu_ManageLibrary
   return "Global | Library | Manage | Menu"
end submenu_ManageLibrary

on submenu_Archive
   return "Global | OPN | Save Count | Menu"
end submenu_Archive

on submenu_Mainstack
   return "Global | Script | Mainstack | Menu"
end submenu_Mainstack

on _
end _

on submenu_Teamster
   return "Global | Teamster | Menu"
end submenu_Teamster

on submenu_TextStack
   return "Global | Object | Export | Test | Menu"
end submenu_TextStack

on _
end _

on submenu_Place
   return "Global | Place | Menu"
end submenu_Place

on menu_LibraryProjectData
   put library_FetchProjectData() into libraryProjectData
   display_Array libraryProjectData, "library_FetchProjectData()", "Global | Library | Project | Model | Menu", "Global | Library | Project | Model | Line | Menu"
end menu_LibraryProjectData

on menu_ListLoadedStacks indexView
   put revLoadedStacks ("all") into stackNames
   filter stackNames with "rev*"
   display_Stacks stackNames, indexView
end menu_ListLoadedStacks

on menu_ListIdeLibraryHandlers
   -- put the revAvailablehandlers of stack "revIdeLibrary"
   put the name of stack "revIdeLibrary" into scriptObject
   
   put the script_ShortHkeys of stack "revIdeLibrary" into hKeys
   filter hKeys with "* rev*"
   sort hKeys by word 2 of each
   display_ScriptObject scriptObject, "revIdeLibrary", hKeys
end menu_ListIdeLibraryHandlers

on _
end _

on menu_TidyProjectLibrary
   library_TidyProjectModel
end menu_TidyProjectLibrary

on _
end _

on menu_MultipleHilights treeView
   put the multi_Hilites of treeView
end menu_MultipleHilights


--> Dev | Menu | Props
-

--> Menu | Props
-
on menu_Init
   put script_FetchHkeyPlaceArray() into storedHkeyPlaceArray
   put hkeyLine_GetPlaceArray() into hkeyPlaceArray
   put hkeyPlaceArray is not storedHkeyPlaceArray into LocalArray ["storedIsDifferent"]
   return storedHkeyPlaceArray
end menu_Init


--> Display
-
-- command editHandler treeView, lineNums, pathItems
if the optionKey is "Down" then breakpoint

set the itemdelimiter to slash
put item 1 of pathItems into shortHkeyLine
put item 2 of pathItems into hObject
put word 1 of lineNums into startLineNum
put word 2 of lineNums into endLineNum

put hKeyLine_Construct (shortHkeyLine, hObject) into hTableLine
hkey_Edit hTableLine
end editHandler


--> Deps
-
function hkeyPlaceArray_ExtractDuplicates hkeyPlaceArray
   local duplicatePlaceArray
   repeat for each key hTableKey in hkeyPlaceArray
      get hkeyPlaceArray [hTableKey]
      if the number of lines of keys (it) > 1 then
         put it into duplicatePlaceArray [hTableKey]
      end if
   end repeat
   return duplicatePlaceArray
end hkeyPlaceArray_ExtractDuplicates
