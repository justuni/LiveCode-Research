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
     
     
     ### First Run! Log and Load
     put true into djbLogFirstRun
     put "info" &tab& "preOpenCard" && "<" && the target &tab& internet date &tab& "Timber! Logging and Benchmarking Plugin for LiveCode" into djbLog
     insert the script of stack "Timber!" into front
     
     
     ### Load Preferences
     setupPreferences
     
     
     ### Force-disable PII
     set the enablePII of stack "Timber!" to false
     
     
     ### Setup UI elements
     set the rect of stack "Timber!" to the timber["rect"] of stack "timberPreferences"
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
     if the hilight of cd btn "toggleLiveUpdate" is not true then exit updateLogDisplay
     
     
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
     
     
     ### Update Message
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
     
     ### Build/Load the Preferences Stack
     local prefsPath
     put SpecialFolderPath("support") & "/Timber! for LiveCode/Preferences.livecode" into prefsPath
     
     
     ### Build/Load Preferences
     if there is not a stack prefsPath then
          
          ### Create the Preferences stack and set it's defaults
          create invisible stack "timberPreferences"
          set the timber["rect"] of stack "timberPreferences" to (the rect of stack "Timber!")
          save stack "timberPreferences" as prefsPath
          
          
     else
          
          ### Load the existing Preferences stack
          go invisible stack prefsPath
          
          
     end if
     
     
end setupPreferences



on savePref prefName, prefValue
     
     ### Setup if not loaded
     if there is not a stack "timberPreferences" then setupPreferences
     
     ### Update the Preference
     if prefName is not empty then set the timber[prefName] of stack "timberPreferences" to prefValue
     
     ### Save Preferences
     save stack "timberPreferences"
     
end savePref



on moveStack
     
     ### Store these settings:
     set the timber["rect"] of stack "timberPreferences" to (the rect of stack "Timber!")
     
     ### Save Preferences
     savePref
     
     pass moveStack
end moveStack



on resizeStack
     
     ### Store these settings:
     set the timber["rect"] of stack "timberPreferences" to (the rect of stack "Timber!")
     
     ### Save Preferences
     savePref
     
     pass resizeStack
end resizeStack


