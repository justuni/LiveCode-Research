script "libDB"
local sDBID

-- libDBCloseConnection
--
-- Close the current database connection.
--
command libDBCloseConnection pDBID
   if pDBID is empty then
      put sDBID into pDBID
   end if
   
   if pDBID is not empty then
      revCloseDatabase pDBID
      if the result is not empty then
         throw "libDBError: Error when disconnecting from database." && the result
      else if pDBID is sDBID then
         put empty into sDBID
      end if
   end if
end libDBCloseConnection

-- libDBConnect
--
-- Open a databse connection.
--
command libDBConnect pType, pHost, pDB, pUser, pPassword 
   get revOpenDatabase(pType, pHost, pDB, pUser, pPassword, empty, empty)
   if it is an integer then
      put it into sDBID
      
      switch revDatabaseType(sDBID)
         case "mysql"
            break
         case "postgresql"
            break
         case "sqlite"
            libDBExecute "PRAGMA encoding='UTF-8'"
            break
      end switch
      
      return sDBID
   else 
      put empty into sDBID
      throw "libDBError: Unable to connect to database." && it
   end if
end libDBConnect

-- libDBExecute
--
-- Execute the given SQL statement.
--
command libDBExecute pQuery
   local tQueryParams
   if the paramCount > 1 then
      if param(2) is an array then
         put param(2) into tQueryParams
      else
         local tArrayIndex
         repeat with tCount = 2 to the paramCount
            put textEncode(param(tCount), "UTF-8") into tQueryParams[tArrayIndex]
            add 1 to tArrayIndex
         end repeat
      end if
   end if
   
   revExecuteSQL sDBID, pQuery, "tQueryParams"
   if the result is not an integer then
      throw "libDBError: Error executing sql." && the result
   else
      return the result
   end if
end libDBExecute

-- libDBInsert
--
-- Inserts the given data into the given table.  
-- The data is arranged in array as field name => value.
-- Returms the inset ID if valid.
--
command libDBInsert pTable, pData
   local tQuery, tValues
   put "INSERT INTO" && pTable & "(" into tQuery
   put "VALUES (" into tValues
   
   local tQueryParams, tParamCount
   put 1 into tParamCount
   repeat for each key tKey in pData
      local tValue
      put pData[tKey] into tValue
      
      _libDBFormatValue tKey, tValue, tQueryParams, tParamCount
      put tKey & comma after tQuery
      put tValue & comma after tValues
   end repeat
   
   delete the last char of tQuery
   delete the last char of tValues
   put tQuery & ")" && tValues & ")" into tQuery
   
   libDBExecute tQuery, tQueryParams
end libDBInsert

private command _libDBFormatValue @xKey, @xValue, @xQueryParams, @xParamCount
   if xKey begins with "*i" or xKey begins with "*f" then
      delete char 1 to 3 of xKey
      put textEncode(xValue, "UTF-8") into xValue
   else
      local tParamNo
      if xKey begins with "*b" then
         put "*b" & xParamCount into tParamNo
         delete char 1 to 3 of xKey
      else
         put xParamCount into tParamNo
      end if
      
      put textEncode(xValue, "UTF-8") into xQueryParams[tParamNo]
      put ":" & xParamCount into xValue
      add 1 to xParamCount
   end if
end _libDBFormatValue
