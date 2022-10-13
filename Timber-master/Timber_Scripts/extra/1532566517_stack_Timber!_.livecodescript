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
               put cr& "bench" &tab& logSender &tab& internet date &tab& "Benchmarking started:" && djbBenchmark["start"] after djbLog
               break
               
          case "stop"
               -- Stop Time
               put milliseconds() into djbBenchmark["stop"]
               put cr& "bench" &tab& logSender &tab& internet date &tab& "Benchmarking ended:" && djbBenchmark["stop"] after djbLog
               
               put djbBenchmark["stop"] - djbBenchmark["start"] into djbBenchmark["total"]
               put cr& "bench" &tab& logSender &tab& internet date &tab& "Benchmark duration:" && djbBenchmark["total"] after djbLog
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
