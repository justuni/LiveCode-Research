Script "stack_Timber!_card_id_1002"

/*
# Name: card "LogUI" of stack "Timber!"
# ID: card id 1002 of stack "Timber!"
*/


global logUpdateID,logUpdateDelay

on preOpenCard
     global djbLog,djbLogFirstRun
     
     ### Skip if already done
     if djbLogFirstRun is true then pass preOpenCard
     
     
     ### First run, log and load
     put true into djbLogFirstRun
     put "info" &tab& "preOpenCard" && "<" && the target &tab& internet date &tab& "Timber! Logging and Benchmarking Plugin for LiveCode" into djbLog
     insert the script of stack "Timber!" into front
     
     
     ### User Preferences
     setupPreferences
     
     
     ### Window Position
     if getPref("rect") is not empty then ### Last known position
          set the rect of stack "Timber!" to getPref("rect")
     else ### Center of the display
          set the width of stack "Timber!" to 848
          set the height of stack "Timber!" to 246
          set the loc of stack "Timber!" to the screenloc
     end if
     
     
     ### Force-disable PII
     set the enablePII of stack "Timber!" to false
     set the hilite of cd btn "togglePersonal" of stack "Timber!" to the enablePII of stack "Timber!"
     
end preOpenCard


on openCard
     
     ### Display the Log
     updateLogDisplay
     
end openCard



on closeCard
     
     ### Cancel Pending Messages
     cancel logUpdateID
     
end closeCard



on updateLogDisplay
     global djbLog
     
     ### Skip if Live Update is disabled
     if the hilight of cd btn "toggleLiveUpdate" is not true then
          
          ### Queue the next UI update and bail
          send "updateLogDisplay" to this card in 1 second
          put the result into logUpdateID
          exit updateLogDisplay
          
     end if
     
     
     ### Save the Horizontal, Vertical, Formatted Height of the log
     local saveH,saveV,saveF
     put the hScroll of cd fld "log" into saveH
     put the vScroll of cd fld "log" into saveV
     put the formattedHeight of cd fld "log" into saveF
     
     
     ### Update the UI
     lock screen
     put djbLog into cd fld "log"
     set the hScroll of cd fld "log" to saveH
     set the vScroll of cd fld "log" to saveV
     if the mouse is not down then set the vScroll of cd fld "log" to the formattedHeight of cd fld "log"
     
     
     ### Queue the next UI Update
     send "updateLogDisplay" to this card in 1 second
     put the result into logUpdateID
     
     
end updateLogDisplay



on exportLog
     global djbLog
     local logPath
     
     ### Build the File Name
     put "Timber! Log" && long internet date & ".txt" into logPath
     replace ":" with "" in logPath
     
     
     ### Ask where to save the log file
     ask file "Save log as" with logPath
     if it is empty then exit to top
     put it into logPath
     
     
     ### Save the Data
     open file logPath for write
     write djbLog to file logPath
     close file logPath
     
     
     ### Log that this log was saved, with the path as PII
     timberLog "Log exported to disk", logPath, "exportLog"
     
     
end exportLog



on setupPreferences
     global prefsPath
     
     ### Build the Takeout! Preferences Directory and Stack
     put SpecialFolderPath("support") & "/Timber for LiveCode" into prefsPath
     if there is not a folder prefsPath then create folder prefsPath
     put "/Preferences.livecode" after prefsPath
     if there is not a stack prefsPath then create invisible stack "timberPreferences" else go invisible stack prefsPath
     
end setupPreferences



on savePref prefName, prefValue
     global prefsPath
     
     ### Setup if not loaded
     if there is not a stack "timberPreferences" then setupPreferences
     
     ### Update the Single Preference
     if prefName is not empty then set the timber[prefName] of stack "timberPreferences" to prefValue
     
     ### Save All Preferences
     save stack "timberPreferences" as prefsPath
     
end savePref



function getPref prefName
     
     ### Setup if not loaded
     if there is not a stack "timberPreferences" then setupPreferences
     
     ### Return the Preference
     return (the timber[prefName] of stack "timberPreferences")
     
end getPref



on moveStack
     
     ### Save Preferences
     savePref "rect", the rect of stack "Timber!"
     
     pass moveStack
end moveStack



on resizeStack
     
     ### Save Preferences
     savePref "rect", the rect of stack "Timber!"
     
     pass resizeStack
end resizeStack


