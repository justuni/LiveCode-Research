Script "stack_Timber!_"

/*
# Name: stack "Timber!"
# ID: stack "Timber!"
*/


### Timber! Logging and Benchmarking Plugin for LiveCode
### Privacy On by Default
### https://github.com/speedbump1981/Timber


### Display the main UI
on timberView
     if the mode of stack "Timber!" is 4 then
          close stack "Timber!"
     else
          palette stack "Timber!"
     end if
end timberView


### Add an entry to the log
on timberLog logMessage, personalData, logSender, logType, benchSignal
     global djbLog,djbBenchmark
     local logTarget
     
     ### Save the target
     put the target into logTarget
     
     
     ### Benchmarking
     switch benchSignal
          
          case "start"
               -- Start Time
               put milliseconds() into djbBenchmark["start"]
               put cr& "bench" &tab& logSender &tab& internet date &tab& "Started benchmark at" && djbBenchmark["start"] && "milliseconds" after djbLog
               break
               
          case "stop"
               -- Stop Time and Elapsed Time
               put milliseconds() into djbBenchmark["stop"]
               put cr& "bench" &tab& logSender &tab& internet date &tab& "Stopped benchmark at" && djbBenchmark["stop"] && "milliseconds" after djbLog
               put djbBenchmark["stop"] - djbBenchmark["start"] into djbBenchmark["total"]
               put cr& "bench" &tab& logSender &tab& internet date &tab& "Duration:" && clockFace(djbBenchmark["total"]) && "(" & djbBenchmark["total"] && "milliseconds)" after djbLog
               break
               
          case "lap"
               -- Laps (Not Supported Yet)
               
     end switch
     
     
     ### PII: Append PII if Enabled and not empty
     if the enablePII of stack "Timber!" is true and personalData is not empty then put " (PII:" && personalData & ")" after logMessage
     
     
     ### logType defaults to "info"
     if logType is empty then put "info" into logType
     if logSender is empty then put "unknown" into logSender
     
     
     ### Update the Log
     put cr& logType &tab& logSender && "<" && logTarget &tab& internet date &tab& logMessage after djbLog
     
end timberLog



private function clockFace tElapsed
     ### Adapted from Klaus and bn @ http://forums.livecode.com/viewtopic.php?t=13090
     local tDays,tHours, tMinutes, tSeconds, tMilliseconds, tRemaining
     set the numberformat to "00"
     put tElapsed div(24*60*60*1000) into tDays
     put tElapsed mod(24*60*60*1000) into tRemaining
     put tRemaining div(60*60*1000) into tHours
     put tRemaining mod(60*60*1000) into tRemaining
     put tRemaining div (60*1000) into tMinutes
     put tRemaining mod (60*1000) into tRemaining
     put tRemaining div(1000) into tSeconds
     put tRemaining mod (1000) into tMilliseconds
     return ( tDays & ":" & tHours & ":" & tMinutes & ":" & tSeconds & "." & tMilliseconds )
end clockFace


