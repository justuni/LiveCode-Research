script "lib_WatchFiles"
--> MetaData
-
license: GPLv3
name: lib_WatchFiles
type: library
version: 0.4

/*
We store information abut the files and folders being watched in a local array (LocalWatchArray).

"watch_Files" takes a fixed list of files to watch. You can set many watches.
This allows you to watch specific files across many folders.

Not done yet:  You can either watch a folder of a list of files. A folder is useful for folders that may change the content of the files inside.
Each time the watch iterates it looks inside the folder and chacks for any changes.
*/

--> Variables
-
local LocalWatchArray


--> Watch | Files
-
command watch_Files filesToWatch, pWatchName, pWaitTicks, pController
   /*
   Public interface to starting and stopping a watch on a set of files
   You can set multiple watches by giving each watch a diffeent name
   Each watch is dispatched together every pWaitTicks (defaults to 30 ticks"
   
   Use "watch_Files false, pWatchName" to stop a watch
   or ""watch_Files listOfLongFiles" to start a watch
   */
   
   switch
      case filesToWatch is false
         breakpoint
         watch_Stop pWatchName
         return false
         break
      case filesToWatch is not empty
         -- delete variable LocalWatchArray -- for now (debugging)
         
         -- first time, so let's initialise local variable
         watch_Init filesToWatch, pWatchName, pWaitTicks, pController
         watch_Files
      case filesToWatch is empty
         -- should be looping
         watch_Loop
         break
   end switch
end watch_Files

command watch_StopWatchingFile fileToRemove, pWatchName
   if pWatchName is empty then put "watch" into pWatchName
   delete variable LocalWatchArray ["watch"][pWatchName]["watchFiles"][fileToRemove]
   put watch_ListWatchFiles (pWatchName) into watchedFiles
   if watchedFiles is empty then
      -- there are no files in the watch
      -- so let's stop the watch
      watch_Stop pWatchName
   end if
end watch_StopWatchingFile

command watch_Stop pWatchName
   watch_CancelPending
   if pWatchName is empty then
      delete variable LocalWatchArray
   else
      delete variable LocalWatchArray ["watch"][pWatchName]
   end if
end watch_Stop

command watch_Loop
   -- must not be private to accept "send"
   
   if watch_ListWatchNames() is empty then return false
   put watch_GetWaitTicks() into waitTicks
   
   repeat for each key watchName in LocalWatchArray ["watch"]
      watch_CheckFiles watchName
   end repeat
   
   send "watch_Loop" to me in waitTicks
   return true
end watch_Loop

private command watch_CheckFiles watchName
   put watch_GetController (watchName) into watchController
   put watch_GetWatchFileArray (watchName) into watchFileArray
   
   repeat for each key watchFile in watchFileArray
      put watchFileArray [watchFile] into oldHash
      
      put url ("file:" & watchFile) into someText
      put sha1_Hash (someText) into newHash
      
      switch
         case there is not a file watchFile
            dispatch "watch_FileDeleted" to watchController with watchFile,watchName -- maybe send more information ?
            break
         case oldHash is empty
            dispatch "watch_FileAdded" to watchController with watchFile,watchName -- maybe send more information ?
            put newHash into LocalWatchArray ["watch"][watchName]["watchFiles"][watchFile]
            break
         case newHash is not oldHash  
            dispatch "watch_FileChanged" to watchController with watchFile,watchName -- maybe send more information ?
            put newHash into LocalWatchArray ["watch"][watchName]["watchFiles"][watchFile]
            break
         default
            -- lcw_Notify the time
            dispatch "watch_FileSame" to watchController with watchFile,watchName -- maybe send more information ?
      end switch
   end repeat
end watch_CheckFiles


--> Watch | Pending
-
function watch_GetPending
   put the pendingmessages into tPendingMsgs
   repeat for each line someLine in tPendingMsgs
      if item 3 of someLine = "watch_Loop" then
         put someLine & CR after pendingWatchMessages
      end if
   end repeat
   delete char -1 of pendingWatchMessages
   return pendingWatchMessages
end watch_GetPending

command watch_CancelPending
   /*
   * the message ID
   * the time the message is scheduled for
   * the message name
   * the long ID property of the object that the message will be sent to
   */
   
   put the pendingmessages into tPendingMsgs
   repeat for each line someLine in tPendingMsgs
      if item 3 of someLine = "watch_Loop" then
         cancel item 1 of someLine
      end if
   end repeat
end watch_CancelPending


--> Watch | Messages
-
/*
Here we list some default message handlers, which should be intercepted in the watch controller.
These handlers are not required.
*/

on watch_FileChanged someFile, watchName
   put someFile
   lcw_Notify word 1 of the params
end watch_FileChanged

on watch_FileSame someFile, watchName
   -- called a lot
   pass watch_FileSame
end watch_FileSame

on watch_FileAdded  watchFile, watchName
   put someFile
   lcw_Notify word 1 of the params
   breakpoint
end watch_FileAdded

on watch_FileDeleted watchFile, watchName
   -- a default which you can override in the watchcontroller
   breakpoint
   watch_StopWatchingFile watchFile, watchName
end watch_FileDeleted


--> Watch | Utils
-
function watch_ListWatchNames
   put the keys of LocalWatchArray ["watch"] into watchNames
   sort watchNames
   return word 1 to -1 of watchNames
end watch_ListWatchNames

function watch_ListShortWatchFiles pWatchName
   put watch_ListWatchFiles (pWatchName) into watchFiles
   set the itemdelimiter to slash
   repeat for each line watchFile in watchFiles
      put item -1 of watchFile & CR after shortWatchFiles
   end repeat
   delete char -1 of shortWatchFiles
   return shortWatchFiles
end watch_ListShortWatchFiles

function watch_ListWatchFiles pWatchName
   put watch_GetWatchFileArray (pWatchName) into watchFileArray
   put the keys of watchFileArray into watchFiles
   sort watchFiles
   return word 1 to -1 of watchFiles
end watch_ListWatchFiles

function watch_GetController pWatchName
   if pWatchName is empty then put "watch" into pWatchName
   put LocalWatchArray ["watch"][pWatchName]["watchController"] into watchController
   return watchController
end watch_GetController

command watch_SetController watchController, pWatchName
   if pWatchName is empty then put "watch" into pWatchName
   put watchController into LocalWatchArray ["watch"][pWatchName]["watchController"]
end watch_SetController

function watch_GetActive pWatchName
   put watch_GetStartedWatching (pWatchName) into startedWatching
   return startedWatching is not empty
end watch_GetActive


--> Watch | Private
-
private command watch_Init filesToWatch, pWatchName, pWaitTicks, pController
   if pWatchName is empty then put "watch" into pWatchName
   if pController is empty then put the long id of the target into pController
   
   watch_SetWaitTicks pWaitTicks
   watch_SetController pController, pWatchName
   watch_SetFiles filesToWatch, pWatchName
   watch_SetActive true, pWatchName
end watch_Init

private function watch_GetWatchFileArray pWatchName
   if pWatchName is empty then put "watch" into pWatchName
   put LocalWatchArray ["watch"][pWatchName]["watchFiles"] into watchFileArray
   return watchFileArray
end watch_GetWatchFileArray

private function watch_GetWatchArray pWatchName
   if pWatchName is empty then put "watch" into pWatchName
   put LocalWatchArray ["watch"][pWatchName] into watchArray
   return watchArray
end watch_GetWatchArray

private command watch_SetActive someBoolean, pWatchName
   if someBoolean is true then
      watch_SetStartedWatching pWatchName
   else
      watch_Stop pWatchName
   end if
end watch_SetActive

private function watch_GetStartedWatching pWatchName
   if pWatchName is empty then put "watch" into pWatchName
   put LocalWatchArray ["watch"][pWatchName]["startedWatching"] into startedWatchingMilliseconds
   return startedWatchingMilliseconds
end watch_GetStartedWatching

private command watch_SetStartedWatching pWatchName
   if pWatchName is empty then put "watch" into pWatchName
   put the milliseconds into LocalWatchArray ["watch"][pWatchName]["startedWatching"]
end watch_SetStartedWatching

function watch_GetFiles pWatchName
   if pWatchName is empty then put "watch" into pWatchName
   put LocalWatchArray ["watch"][pWatchName]["watchFiles"] into watchFileArray
   put keys(watchFileArray) into watchFiles
   sort watchFiles
   return watchFiles
end watch_GetFiles

private command watch_SetFiles filesToWatch, pWatchName
   if pWatchName is empty then put "watch" into pWatchName
   
   repeat for each line watchFile in filesToWatch
      if there is not a file watchFile then next repeat
      
      put url ("file:" & watchFile) into someText
      put sha1_Hash (someText) into newHash
      put newHash into LocalWatchArray ["watch"][pWatchName]["watchFiles"][watchFile]
   end repeat
end watch_SetFiles

private function watch_GetWaitTicks
   put LocalWatchArray ["waitTicks"] into waitTicks
   if waitTicks is empty then put 30 into waitTicks
   return waitTicks
end watch_GetWaitTicks

private command watch_SetWaitTicks waitTicks
   put waitTicks into LocalWatchArray ["waitTicks"]
end watch_SetWaitTicks
