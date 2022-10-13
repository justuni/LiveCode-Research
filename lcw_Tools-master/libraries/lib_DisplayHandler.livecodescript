script "lib_DisplayHandler"
--> MetaData
-
license: GPLv3
name: lib_DisplayHandler
type: library
version: 0.1


--> Display | Events
-
on mouse_EditHkey treeView, hTableLine
   if the optionKey is "Down" then breakpoint
   
   put the hilited_Element of treeView into hElement
   switch item 1 of hElement
      case "Missing"
         -- put hTableLine into parentTableLine
         put item -1 of hElement into missingTableLine
         put hTableLine into missingParent
         hkey_Edit missingParent
         put missingTableLine
         break
      case "Calls"  
         if the shiftKey is "Down" then
            put item 5 of hElement into hKeyLine
         else
            put item 4 of hElement into hKeyLine
         end if
         put item 3 of hElement into stackObject
         
         hkey_Edit hKeyLine
         
         put hkeyLine_FetchDuplicateArray (hKeyLine) into duplicateArray
         put keys (duplicateArray) into dupHkeys
         if the number of lines of dupHkeys > 1 then
            put merge ("[[hKeyLine]],duplicateArray") into someTitle
            put empty into mLineTitle
            display_Array duplicateArray, someTitle, "Global | Hkey | Duplicate | Menu", mLineTitle, "hkeyLine_TreeClick", "hkeyLine_TreeClick"
         end if
         break
      case "Handlers"
         put item -1 of hElement into hKeyLine
         hkey_Edit hKeyLine
         break
      default
         put item 1 of hElement into dObject
         put hTableLine into lineNums
         put the title_Text of treeView into hKeyLine
         -- put the displayed_Title of treeView into hTableLine
         -- put hKeyLine_Construct (shortHkeyLine, dObject) into hKeyLine
         hkey_Edit hKeyLine
   end switch
end mouse_EditHkey


--> Display | HandlerDeps
-
command display_HandlerDeps hKeyLine
   put hkeyLine_WalkExportedHkeyArray (hKeyLine) into hKeyArray
   put hkeyArray_ToProjectDependencyArray (hKeyArray) into projectDependencyArray
   
   put merge ("[[hKeyLine]],display_HandlerDeps") into someTitle
   put empty into mLineTitle
   display_Array projectDependencyArray, someTitle, "Global | HkeyArray | Tree | Menu", mLineTitle, "hkeyLine_TreeClick", "hkeyLine_TreeClick"
   put the result into treeView
   set the displayed_Hkey of treeView to hKeyLine
   
   set the view_Data of treeView to hKeyArray
   set the displayed_Style of treeView to "Project Dependency Array"
   return treeView
end display_HandlerDeps


--> Deps
-
function hkeyArray_ToProjectDependencyArray hTableLineArray
   local pDepArray
   repeat for each key hTableLine in hTableLineArray
      -- not strictly need. Skip for speed?
      put hkeyArray_FindParentArray (hTableLine, hTableLineArray) into parentArray
      put keys (parentArray) into parentkeys
      
      addTableLine pDepArray, hTableLine, parentArray
      put hTableLineArray [hTableLine] into hTableLineCallArray
      repeat for each key hTableLineCall in hTableLineCallArray
         addTableLine pDepArray, hTableLineCall, hTableLine
      end repeat
   end repeat
   return pDepArray
end hkeyArray_ToProjectDependencyArray


--> hkeyLine | Walk
-
getprop exported_HandlerHkeyArray [shortHkey]
   put the long id of the target into tObject
   hkey_Deconstruct shortHkey, hName, hType, hObject, hNum
   put revRuggedID (tObject) into hObject
   put hKeyLine_FromTripple (hName, hType, hObject) into hKeyLine
   put hkeyLine_WalkExportedHkeyArray (hKeyLine) into hKeyArray
   return hKeyArray
end exported_HandlerHkeyArray

function hkeyLine_WalkExportedHkeyArray hKeyLine, pProjectName
   /*
   Works out dependecy array from flat namespace of all hkeys in hkeyPlaceArray library.
   Does not look at pProjectName at the moment (for that need to return different arrays with "script_FetchHkeyPlaceArray (pProjectName)")
   */
   
   local hKeyLinkArray
   
   put script_FetchHkeyPlaceArray (pProjectName) into hkeyPlaceArray
   put hkey_FetchCalls (hKeyLine) into shortCallHkeyLines
   repeat for each line shortCallHkeyLine in shortCallHkeyLines 
      hkeyLine_WalkExportedHkeyArray shortCallHkeyLine, hKeyLine, hKeyLinkArray, hkeyPlaceArray
   end repeat
   return hKeyLinkArray
end hkeyLine_WalkExportedHkeyArray

private command hkeyLine_WalkExportedHkeyArray shortCallHkeyLine, parentHKeyLine, @hKeyLinkArray, hkeyPlaceArray
   hKeyLine_Deconstruct shortCallHkeyLine, cName, cType, hObject
   put hkey_GetPlace (shortCallHkeyLine, hkeyPlaceArray) into cObject -- find it
   -- put hkey_Find (hName, hType, externalObjects) into externalHkey
   
   if exists (cObject) is false then 
      put hKeyLine_Construct (shortCallHkeyLine, "Missing") into missingCall
      put true into hKeyLinkArray [parentHKeyLine][missingCall]
      return empty
   end if
   
   put hKeyLine_Construct (shortCallHkeyLine, cObject) into foundCall
   if hKeyLinkArray [parentHKeyLine][foundCall] is true then
      return empty -- already indexed (don't recurse)
   end if
   
   -- add it to the array
   put true into hKeyLinkArray [parentHKeyLine][foundCall]
   
   -- now lets repeat and recurse for each call found
   put hkey_FetchCalls (foundCall) into childShortHkeyLines   
   repeat for each line childShortHkeyLine in childShortHkeyLines
      hkeyLine_WalkExportedHkeyArray childShortHkeyLine, foundCall, hKeyLinkArray, hkeyPlaceArray
   end repeat
   
   return empty
end hkeyLine_WalkExportedHkeyArray

private command addTableLine @pDepArray, hTableLine, parentTableLine
   hKeyLine_Deconstruct hTableLine, cName, cType, cObject
   if exists (cObject) is false then
      put parentTableLine into pDepArray ["Missing"][hTableLine]
   else
      put the project_Name of cObject into cProjectName
      put parentTableLine into pDepArray ["Calls"][cProjectName][cObject][hTableLine]
   end if
end addTableLine

function hkeyArray_FindParentArray hTableLine, hTableLineArray
   repeat for each key testTableLine in hTableLineArray
      put hTableLineArray [testTableLine] into hTableLineCallArray
      if hTableLineCallArray  [hTableLine] is true then
         put true into parentArray [testTableLine]
      end if
   end repeat
   return parentArray
end hkeyArray_FindParentArray
