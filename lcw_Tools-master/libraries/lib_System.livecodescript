script "lib_System"
--> MetaData
-
license: GPLv3
name: lib_System
type: library
version: 0.2


--> System | Target
-
function script_CallingObject pNum
   if pNum is empty then put 1 into pNum
   put (pNum + 2) * -1 into lineNum
   get the executioncontexts
   put item 1 of line lineNum of it into callingObject
   return callingObject
end script_CallingObject

function script_CallingHkey pNum
   if pNum is empty then put 1 into pNum
   put (pNum + 2) * -1 into lineNum
   put line lineNum of the executioncontexts into exLine
   put item 1 of exLine into hObject
   put item 2 of exLine into hName
   put item 3 of exLine into lineNum
   put item 4 to -1 of exLine into behaviorObjects
   
   put word 1 to -1 of hObject & CR & behaviorObjects into objectIndex
   put hkeyLine_FindHandlerInObjects (hName, objectIndex) into hkeyLines
   put line 1 of hkeyLines into hkeyLine
   
   return hkeyLine
end script_CallingHkey

function system_TopTarget
   put item 1 of line 1 of the executioncontexts into topTarget
   return topTarget
end system_TopTarget

function system_ListHkeyTargets
   put _ParseExecutionContexts (the executioncontexts) into contextArray
   put item 2 of the extents of contextArray into maxNum
   repeat with indexNum = 1 to maxNum
      put contextArray [indexNum]["handler"] into hName
      put contextArray [indexNum]["object"] into hObject
      
      put contextArray [indexNum]["line number"] into lineNum
      put contextArray [indexNum]["parents"] into behaviorObjects
      
      put word 1 to -1 of hObject & CR & behaviorObjects into objectIndex
      put hkeyLine_FindHandlerInObjects (hName, objectIndex) into hkeyLines
      
      -- we are not distinguishing types of handlers here 
      if the number of lines of hkeyLines > 1 then
         breakpoint
      end if
      put line 1 of hkeyLines into hkeyLine
      
      if hkeyLine is empty then
         put hKeyLine_FromTripple (hName, "?", "?") & CR after targetIndex
      else
         put hkeyLine & CR after targetIndex
      end if
   end repeat
   delete char -1 of targetIndex
   return targetIndex
end system_ListHkeyTargets

function hkeyLine_FindHandlerInObjects hName, objectIndex
   repeat for each line someObject in objectIndex
      if exists (someObject) is false then
         breakpoint
         next repeat
      end if
      put the revavailableHandlers of someObject into hTable
      put revRuggedID (someObject) into hObject
      repeat for each line hTableLine in hTable
         if word 2 of hTableLine = hName then
            put hKeyLine_Construct (hTableLine, hObject) into hkeyLine
            put hkeyLine & CR after hkeyLines
         end if
      end repeat
   end repeat
   delete char - 1 of hkeyLines
   return hkeyLines
end hkeyLine_FindHandlerInObjects

function system_ListTargets
   get the executioncontexts
   repeat for each line someLine in it
      put item 1 of someLine & CR after targetIndex
   end repeat
   delete char -1 of targetIndex
   return targetIndex
end system_ListTargets


--> Script | ExecutionContexts
-
command display_ExecutionContexts pTitle
   if pTitle is empty then put "Execution Contexts,hKeys" into pTitle
   put system_ListHkeyTargets() into hkeyLines
   display_HkeyLines hkeyLines, pTitle
   put the result into indexView
   return indexView
end display_ExecutionContexts

private function _ParseExecutionContexts pContexts
   -- not sure why this is so complicated
   -- seems like we need to find the lineNum ?
    -----
    local theContext
    local theContextsA
    local theItem
    -----
    ## Each line has object-long-id,handler-name,line-number,[parent script object][,]
    ## Beware of quotes and commas in stack path name. They will get you.
    ## How to properly parse?
    
    ## How many entries?
    repeat for each line theContext in pContexts
        add 1 to theIndex
        put 0 into theItemNo
        repeat for each item theItem in theContext
            add 1 to theItemNo
            if theItem is an integer then
                ## found the line number
                put theItem into theContextsA[theIndex]["line number"]
                put item (theItemNo - 1) of theContext into theContextsA[theIndex]["handler"]
                put item 1 to (theItemNo - 2) of theContext into theContextsA[theIndex]["object"]
                 
                put item (theItemNo + 1) to -1 of theContext into theContextsA[theIndex]["parents"]
            end if
        end repeat
    end repeat
    return theContextsA
 end _ParseExecutionContexts
  

--> Script | ExecutionContexts | Comments
-
function script_GetCommentAboveMe
   get line -2 of the executioncontexts
   put item -1 of it into lineNum
   -- put item -2 of it into hName
   put item 1 to -3 of it into scriptObject
   put the script of scriptObject into someScript
   
   -- test until we find a line with content
   repeat with testLineNum = (lineNum - 1) down to 1
      put word 1 to -1 of line testLineNum of someScript into scriptLine
      if scriptLine is not empty then exit repeat 
   end repeat
   if scriptLine is empty then return empty -- a blank script
   
   switch
      case char 1 to 2 of scriptLine = "--"
         delete char 1 to 2 of scriptLine
         return word 1 to -1 of scriptLine
      case char 1 of scriptLine = "#"
         repeat while char 1 of scriptLine = "#"
            delete char 1 ofscriptLine
         end repeat
         return word 1 to -1 of scriptLine
      case char -2 to -1 of scriptLine = "*/"
         -- a multiline comment
         put testLineNum into lastLineNum
         
         -- test until we find a line with content
         repeat with testLineNum = (lastLineNum - 1) down to 1
            put word 1 to -1 of line testLineNum of someScript into scriptLine
            if char 1 to 2 of scriptLine = "/*" then
               put testLineNum into startLineNum
               put line startLineNum to lastLineNum of someScript into multiComment
               put word 1 to -1 of multiComment into multiComment
               delete char 1 to 2 of multiComment
               delete char -2 to -1 of multiComment
               put word 1 to -1 of multiComment into multiComment
               
               repeat for each line cLine in multiComment
                  put word 1 to -1 of cLine & CR after cleanMultiComment
               end repeat
               delete char -1 of cleanMultiComment
               return cleanMultiComment
            end if
         end repeat
         return empty -- no start of comment ???
      default
         return empty -- not a comment
   end switch
end script_GetCommentAboveMe

function script_GetLineAboveMe
   get line -2 of the executioncontexts
   put item -1 of it into lineNum
   -- put item -2 of it into hName
   put item 1 to -3 of it into scriptObject
   
   put line (lineNum - 1) of the script of scriptObject into scriptLine
   return word 1 to -1 of scriptLine
end script_GetLineAboveMe


--> System
-
getprop screen_Rect [pWhichRect]
   put the stack_Name of the target into stackName
   put the loc of stack stackName into globalTargetLoc
   
   switch pWhichRect
      case "full"
         get the screenRects
         break
      case "effective"
         -- get the effective working screenRects -- rev bug: no longer works unless working is also there
         get the effective working screenRects
         break
      default -- "working"
         get the working screenRects
   end switch
   
   repeat for each line someScreenRect in it
      if globalTargetLoc is within someScreenRect then
         return someScreenRect
      end if
   end repeat
   return empty
end screen_Rect

getprop screen_Num
   put the stack_Name of the target into stackName
   put the loc of stack stackName into globalTargetLoc
   
   get the screenRects
   put 0 into screenNum
   repeat for each line someScreenRect in it
      add 1 to screenNum
      if globalTargetLoc is within someScreenRect then
         return screenNum
      end if
   end repeat
   return empty
end screen_Num

getprop screen_Width
   put the screen_Rect of the target into someRect
   return item 3 of someRect - item 1 of someRect
end screen_Width

getprop screen_Height
   put the screen_Rect of the target into someRect
   return item 4 of someRect - item 2 of someRect
end screen_Height

command screen_GatherStacks pResetTinyRects, pSomeGlobalLoc, pStackNames
   replace comma with CR in screen_GatherStacks
   if pStackNames is empty then
      put the openstacks into pStackNames
   end if
   --
   repeat for each line sName in pStackNames
      stack_RestorePosition sName, pSomeGlobalLoc, pResetTinyRects
   end repeat
end screen_GatherStacks

command stack_RestorePosition pStackName, pSomeGlobalLoc, pResetTinyRects
   if pStackName is empty then 
      put the short name of this stack into pStackName
   end if
   if pSomeGlobalLoc is empty then
      put the screenloc into pSomeGlobalLoc
   end if
   --
   if pResetTinyRects is not false then
      set the visible of stack pStackName to true
      --
      if the width of stack pStackName < 10 then
         breakpoint
         set the with of  stack pStackName to 200
      end if
      if the height of stack pStackName < 10 then
         breakpoint
         set the height of  stack pStackName to 200
      end if
   end if
   --
   set the loc of  stack pStackName to pSomeGlobalLoc
end stack_RestorePosition
   
function system_GetScreenRect screenNum, pWhichRect
   put word -1 of screenNum into screenNum -- allws for "Screen 2" as displayed in menus
   switch pWhichRect
      case "full"
         get the screenRects
         break
      case "effective"
         /*
         Adding the effective adjective to either form returns the area of the screen the application has to itself. 
         In particular, if the keyboard is activated, it take into account if the keyboard is taking up space on the screen. (Android and iOS only)
         */
         
         -- get the effective screenRects -- rev bug
         get the effective working screenRects
         break
      default -- "working"
         /*
         Adding the working adjective to either form returns the virtual co-ordinates of each screen's working-area. 
         The working-area of a screen is defined to be the area not covered by OS furniture (such as the task bar on Windows, and the Dock and Menubar on Mac OS X).
         */
         get the working screenRects
   end switch
   
   return line screenNum of it
end system_GetScreenRect

function system_ListScreenNames
   get the screenRects
   -- put "Primary" & CR into screenNames
   put "Screen 1" & CR into screenNames
   repeat with screenNum = 2 to the number of lines of it
      put "Screen" && screenNum & CR after screenNames
   end repeat
   delete char -1 of screenNames
   return screenNames
end system_ListScreenNames

 function system_NumberOfScreens
    get the screenRects
    return the number of lines of it
 end system_NumberOfScreens
