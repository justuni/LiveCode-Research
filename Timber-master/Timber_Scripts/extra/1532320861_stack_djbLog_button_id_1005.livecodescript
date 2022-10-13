Script "stack_djbLog_button_id_1005"

/*
# Name: button "doPurge" of card "LogUI" of stack "djbLog"
# ID: button id 1005 of card id 1002 of stack "djbLog"
*/


on mouseUp
     global djbLog
     
     ### Disable me
     set the disabled of me to true
     
     ### Clear the Log
     ### (The UI will update automatically)
     put empty into djbLog
     
     ### Enable me in 2 seconds
     send ("set the disabled of" && the long id of me && "to false") to me in 2 seconds
     
end mouseUp
