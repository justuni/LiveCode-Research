Script "stack_Timber!_button_id_1006"

/*
# Name: button "toggleLiveUpdate" of card "LogUI" of stack "Timber!"
# ID: button id 1006 of card id 1002 of stack "Timber!"
*/


on mouseUp
     if the flag of me is empty then set the flag of me to false
     set the flag of me to not the flag of me
     
     set the hilight of me to the flag of me
end mouseUp
