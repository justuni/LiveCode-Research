script "lib_DisplayStack"
--> MetaData
-
license: GPLv3
name: lib_DisplayStack
type: library
version: 0.2


--> hkeyLine | Walk
-
command display_ScriptArray scriptObject
   put the script_HkeyArray of scriptObject into hKeyArray
   script_CreateGraph hkeyArray, scriptObject
   --
   put the result into imageFile
   display_HandlerSVG imageFile
   --
   put the name of scriptObject into objectName
   put merge ("[[objectName]],display_ScriptArray") into someTitle
   put "Global | HkeyArray | Tree | Deps | Menu" into mTitle
   put "Global | HkeyArray | Menu" into mLineTitle
   --
   display_Array hKeyArray, someTitle, mTitle, mLineTitle, "mouse_EditHkey", "mouse_EditHkey"
   put the result into treeView
   set the displayed_Object of treeView to scriptObject
   return indexView
end display_ScriptArray

command display_StackDeps stackObject
   put the project_Name of stackObject into projectName
   --
   put the stack_PlaceArray of stackObject into pDepArray
   put the script_HkeyArray of stackObject into pDepArray
   
   -- 
   put merge ("[[stackObject]],[[projectName]]") into someTitle
   put "Global | HkeyArray | Tree | Deps | Menu" into mTitle
   put "Global | HkeyArray | Menu" into mLineTitle
   display_Array pDepArray, someTitle, mTitle, mLineTitle, "mouse_EditHkey", "mouse_EditHkey"
   put the result into treeView
   set the displayed_Object of treeView to stackObject
   return indexView
end display_StackDeps

getprop script_HkeyArray [externalObjects]
   local hKeyLinkArray
   --
   put the long id of the target into targetObject
   put walk_TargetHandlers (targetObject) into hKeyArray
   return hKeyArray
end script_HkeyArray

function walk_TargetHandlers targetObject, pExternalObjects, pUseExportedCalls
   local hKeyLinkArray
   put revRuggedID (targetObject) into rObject
   put the revAvailableHandlers of rObject into hTable
   repeat for each line hLine in hTable
      set the cursor to busy
      put word 1 to 2 of hLine into shortHkey
      put hKeyLine_Construct (shortHkey, rObject) into hKeyLine
      --
      if pUseExportedCalls is true then
         put hkey_FetchCalls (hKeyLine) into shortCallHkeyLines
      else
         put the handler_Calls [hKeyLine] of targetObject into shortCallHkeyLines
      end if
      repeat for each line shortCallHkeyLine in shortCallHkeyLines 
         walk_FoundShortHkeyLine shortCallHkeyLine, hKeyLine, pExternalObjects, hKeyLinkArray
      end repeat
   end repeat
   return hKeyLinkArray
end walk_TargetHandlers

private command walk_FoundShortHkeyLine shortCallHkeyLine, parentHKeyLine, pExternalObjects, @hKeyLinkArray, pUseExportedCalls
   -- was hkeyLine_WalkExportedHkeyArray
   hKeyLine_Deconstruct parentHKeyLine, pName, pType, pObject
   put hkey_FindFirst (shortCallHkeyLine, pObject, pExternalObjects) into foundCall
   --
   if foundCall is empty then 
      put hKeyLine_Construct (shortCallHkeyLine, "Missing") into missingCall
      put true into hKeyLinkArray [parentHKeyLine][missingCall]
      return empty
   end if
   --
   if hKeyLinkArray [parentHKeyLine][foundCall] is true then
      return empty -- already indexed (don't recurse)
   end if
   
   -- add it to the array
   put true into hKeyLinkArray [parentHKeyLine][foundCall]
   
   -- now lets repeat and recurse for each call found
   if pUseExportedCalls is true then
      put hkey_FetchCalls (foundCall) into childShortHkeyLines   
   else
      hKeyLine_Deconstruct foundCall, fName, fType, fObject
      put the handler_Calls [foundCall] of fObject into childShortHkeyLines    
   end if
   repeat for each line childShortHkeyLine in childShortHkeyLines
      set the cursor to busy
      walk_FoundShortHkeyLine childShortHkeyLine, foundCall, pExternalObjects, hKeyLinkArray
   end repeat
   return empty
end walk_FoundShortHkeyLine


--> Display | StackDeps
-
getprop stack_PlaceArray
   /*
   -- see also "hkeyLine_WalkExportedHkeyArray"
   
   This only looks at calls, and hkeys in the actual object.
   It does not walk the dependency tree.
   It is not a recursive search.
   usefull for a quick look at first level dependencies.
   */
   
   local pDepArray
   
   put the long id of the target into tObject
   put the revAvailableHandlers of tObject into hTable
   put the data_Folder of tObject into dataFolder
   put revRuggedID (tObject) into rObject
   
   repeat for each line hTableLine in hTable
      put word 1 to 2 of hTableLine into shortHkey
      put hKeyLine_Construct (shortHkey, rObject) into pHkey
      put handler_FetchCalls (shortHkey, dataFolder) into shortCalls
      put shortCalls into pDepArray ["Handlers"][pHkey]
      
      set the wholematches to false
      repeat for each line shortCall in shortCalls
         /*
         -- put script_FetchHkeyPlaceArray() into hkeyPlaceArray
         
         put shortCall & space into searchString
         if lineOffset (searchString, hTable) > 0 then
            next repeat
         end if
         -- put hkey_GetPlace (shortCall, hkeyPlaceArray) into cObject
         -- put hkey_Find (hName, hType, externalObjects) into externalHkey
         */
         
         put the found_Hkey [shortCall] of tObject into externalHkey
         if externalHkey is empty then
            put empty into pDepArray ["Missing"][rObject][shortCall][pHkey]
         else
            hkey_Deconstruct externalHkey, cName, cType, cObject, cNum
            put the project_Name of cObject into cProjectName
            put hKeyLine_Construct (shortCall, cObject) into cHkey
            put empty into pDepArray ["Calls"][cProjectName][cObject][cHkey][pHkey]
         end if
      end repeat
   end repeat
   return pDepArray
end stack_PlaceArray


--> Display | Stacks
-
command display_Stacks stackNames, pIndexView, pStackTitle
   if pStackTitle is empty then put "Stacks,Environment" into pStackTitle
   
   put "mDouble_DisplayStack" into mDoubleUp
   
   if exists (pIndexView) is false then
      put empty into mUp
      display_Index stackNames, pStackTitle, mTitle, mLineTitle, mUp, mDoubleUp
      put the result into displayView
      return displayView
   else
      lock screen
      set the view_Index of pIndexView to stackNames
      set the stack_Title of pIndexView to pStackTitle
      set the mouse_DoubleUpEvent of pIndexView to mDoubleUp
      unlock screen
      return pIndexView
   end if
end display_Stacks


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

on mDouble_DisplayStackDeps treeView, stackName
   if the controlkey is "Down" then return false
   
   put the name of stack stackName into stackObject
   if the optionKey is "Down" then
      display_StackDeps stackObject
   end if
   edit the script of stackObject
   return true
end mDouble_DisplayStackDeps
