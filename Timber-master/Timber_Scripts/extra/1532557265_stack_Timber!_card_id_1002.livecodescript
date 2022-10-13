Script "stack_Timber!_card_id_1002"

/*
# Name: card "LogUI" of stack "Timber!"
# ID: card id 1002 of stack "Timber!"
*/


global logUpdateID,logUpdateDelay

on preOpenCard
     global djbLog,djbLogFirstRun
     
     ### Make sure we don't reset if the stack has already been prepared
     if djbLogFirstRun is true then pass preOpenCard
     put true into djbLogFirstRun
     put "info" &tab& "preOpenCard" && "<" && the target &tab& internet date &tab& "Timber! Logging and Benchmarking Plugin for LiveCode" into djbLog
     
     
     ### Insert Stack Script
     insert the script of stack "Timber!" into front
     
     
     ### Default window position (for now)
     set the bottomRight of this stack to (item 3 of the screenRect - 64),(item 4 of the screenRect - 64)
     
     
     ### PII: Disabled by default
     set the enablePII of stack "Timber!" to false
     set the hilite of cd btn "togglePersonal" of stack "Timber!" to false
     
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
     local saveH,saveV,saveF
     
     ### Only do this if Live Updating is turned on
     if the hilight of cd btn "toggleLiveUpdate" is true then
          
          ### Save the Horizontal, Vertical, Formatted Height of the log
          put the hScroll of cd fld "log" into saveH
          put the vScroll of cd fld "log" into saveV
          put the formattedHeight of cd fld "log" into saveF
          
          
          ### Update the UI
          lock screen
          put djbLog into cd fld "log"
          
          set the hScroll of cd fld "log" to saveH
          set the vScroll of cd fld "log" to saveV
          unlock screen
          
          ### Stupid fix, but you should be able to scroll the log
          if the mouse is not down then set the vScroll of cd fld "log" to the formattedHeight of cd fld "log"
          
          
          ### Update Message
          send "updateLogDisplay" to this card in 1 second
          put the result into logUpdateID
          
     end if
     
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
     local prefsPath
     
     ### Build/Load the Preferences Stack
     put SpecialFolderPath("support") & "/Timber! for LiveCode/Preferences.livecode" into prefsPath
     
     lock messages
     if there is not a stack prefsPath then
          
          ### Create the Preferences stack and set it's defaults
          create invisible stack "timberPreferences"
          set the timber["rect"] of stack "timberPreferences" to (the rect of stack "Timber!")
          save stack "timberPreferences" as prefsPath
     else
          go invisible stack prefsPath
     end if
     unlock messages
     
     ### Load Default Preferences
     set the rect of stack "Timber!" to the timber["rect"] of stack "timberPreferences"
     
end setupPreferences


