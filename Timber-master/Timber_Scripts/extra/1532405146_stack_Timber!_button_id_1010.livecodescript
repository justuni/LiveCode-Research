Script "stack_Timber!_button_id_1010"

/*
# Name: button "togglePersonal" of card "LogUI" of stack "Timber!"
# ID: button id 1010 of card id 1002 of stack "Timber!"
*/


on mouseUp
     
     ### False (Warn), or True (Turn Off)
     if the enablePII of this stack is false then
          
          ### Display Warning
          answer "Warning: Including Personally Identifiable Information within the Log is not recommended unless you are working directly with the developer." &cr&cr& "Are you sure you want proceed?" with "Yes, Include Personal Info" and "No" 
          if it is "No" then pass mouseUp
          
          ### Enable PII Logging
          set the enablePII of this stack to true
          
     else
          
          ### Disable PII Logging
          set the enablePII of this stack to false
          
     end if
     
     ### Update the UI
     set the hilight of me to the enablePII of this stack
     
     ### Log PII Status
     logSender "info", "mouseUp", "Personally Identifiable Information:" && the enablePII of this stack
     
end mouseUp
