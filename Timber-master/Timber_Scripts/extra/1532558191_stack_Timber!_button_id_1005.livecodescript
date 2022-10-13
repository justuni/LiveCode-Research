Script "stack_Timber!_button_id_1005"

/*
# Name: button "doPurge" of card "LogUI" of stack "Timber!"
# ID: button id 1005 of card id 1002 of stack "Timber!"
*/


on mouseUp
     global djbLog
     
     
     ### Disable me
     set the disabled of me to true
     
     
     ### Clear the Log
     ### (The UI will update automatically)
     put "info" &tab& "mouseUp" && "<" && the target &tab& internet date &tab& "Timber! Logging and Benchmarking Plugin for LiveCode" into djbLog
     
     
     ### False (Warn), or True (Turn Off)
     if (the enablePII of this stack) is true then
          
          ### Disable PII
          set the enablePII of this stack to false
          
          ### Initiate the PII request
          send "mouseUp" to cd btn "togglePersonal" in 1 second
          
     end if
     
     
     ### Enable me in 2 seconds
     send ("set the disabled of" && the long id of me && "to false") to me in 2 seconds
     
end mouseUp
