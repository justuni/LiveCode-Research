script "model_Global"
--> MetaData
-
license: GPLv3
name: model_Global
type: model
version: 0.1


--> Working on
-

--> Global | Names
-
function global_ListNames pFilters
   put the globals into gNames
   replace comma with CR in gNames
   
   if pFilters is empty then
      filter gNames without "gTemp_*"
      -- line_Delete "msg", gNames
      filter gNames without "gREV*"
      filter gNames without "$*"
      filter gNames without "each"
      filter gNames without "msg"
   end if
   
   repeat for each item pFilter in pFilters
      switch
         case pFilter is "rev"
            filter gNames with "gREV*"
            break
         case pFilter is "env"
            filter gNames with "$*"
            break
         case pFilter is empty
         case pFilter is true
            break
         case pFilter is false
            -- line_Delete "msg", gNames
            filter gNames without "gREV*"
            filter gNames without "$*"
            filter gNames without "each"
            filter gNames without "msg"
            break
         case char 1 of pFilter = "-"
            delete char 1 of pFilter
            filter gNames without pFilter
            break
         default
            filter gNames with pFilter
            break
      end switch
   end repeat
   return gNames
end global_ListNames


--> Global | Model
-
function global_Gather pFilters
   put global_ListNames (pFilters) into gNames
   repeat for each line gName in gNames  
      put "global" && gName & CR & "get" && gName into doScript   
      do doScript
      put it into prefsArray [gName]
   end repeat
   return prefsArray
end global_Gather

command global_Load globalArray
   repeat for each key gName in globalArray
      if the number of words of gName is not 1 then next repeat -- safety check
      put globalArray [gName] into globalValue
      put "global" && gName & CR & "put globalValue into" && gName into doScript
      do doScript
   end repeat
end global_Load

function global_GetValue gName
   put "global" && gName & CR & "put" && gName && "into gValue" into doScript
   do doScript
   return gValue
end global_GetValue

command global_SetValue gName, gValue
   put "global" && gName & CR & "put" && gValue && "into gName" into doScript
   do doScript
end global_SetValue

command global_Delete gName
   put "global" && gName & CR & "delete variable" && gName into doScript
   do doScript
end global_Delete

command global_DeleteAll pFilter
   if pFilter is empty then put false into pFilter
   put global_ListNames (pFilter) into prefGlobalNames
   repeat for each line gName in prefGlobalNames
      global_Delete gName
   end repeat
end global_DeleteAll


--> Library | Global Dump | Model
-
command display_GlobalDump
   put library_FetchGlobalDump() into gatheredArray
   display_Array gatheredArray
end display_GlobalDump

command library_RestoreGlobalDump
   put library_FetchGlobalDump() into globalArray
   global_DeleteAll
   global_Load globalArray
   return globalArray
end library_RestoreGlobalDump

function library_FetchGlobalDump
   put lcw_FetchArray ("library_GlobalDump.array") into gatheredArray
   return gatheredArray
end library_FetchGlobalDump

command library_StoreGlobalDump gatheredArray
   lcw_StoreArray "library_GlobalDump.array", gatheredArray
end library_StoreGlobalDump

command library_DeleteGlobalDump
   lcw_DeleteArray "library_GlobalDump.array"
end library_DeleteGlobalDump

function library_GlobalDumpFile
   put lcw_GetArrayFile ("library_GlobalDump.array") into libraryGlobalDumpFiles
   return libraryGlobalDumpFiles
end library_GlobalDumpFile

function library_GlobalDumpFileMissing
   put library_GlobalDumpFile() into libraryGlobalDumpFile
   put there is not a file libraryGlobalDumpFile into fileMissing
   return fileMissing
end library_GlobalDumpFileMissing
