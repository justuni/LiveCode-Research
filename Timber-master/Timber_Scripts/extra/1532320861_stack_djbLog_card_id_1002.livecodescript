Script "stack_djbLog_card_id_1002"

/*
# Name: card "LogUI" of stack "djbLog"
# ID: card id 1002 of stack "djbLog"
*/


global logUpdateID,logUpdateDelay

on preOpenCard
     global djbLogFirstRun
     
     ### Make sure we don't reset if the stack has already been prepared
     if djbLogFirstRun is true then pass preOpenCard
     put true into djbLogFirstRun
     
     
     ### PII: Disabled by default
     set the enablePII of stack "djbLog" to false
     set the hilite of cd btn "togglePersonal" of stack "djbLog" to false
     
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
     put "LOT" && long internet date & ".txt" into logPath
     replace ":" with "" in logPath
     
     
     ### Ask where to save the log file
     ask file "Save log as" with logPath
     if it is empty then exit to top
     put it into logPath
     
     
     ### Log that this log was saved, with the path as PII
     djbLogEntry "info", "exportLog", "Log exported to disk", logPath
     
     
     ### Save the Data
     open file logPath for write
     write djbLog to file logPath
     close file logPath
     
end exportLog


