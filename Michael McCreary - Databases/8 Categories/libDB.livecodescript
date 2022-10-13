script "libDB"
local sDBID

-- libDBConnectionSelect
--
-- Instruct the lib to use the given DB id.
--
command libDBConnectionSelect pDBID
   get revOpenDatabases()
   if pDBID is not among the items of it then
      throw "libDBError:  Unknown database connection id" && pDBID
   else
      put pDBID into sDBID
   end if
end libDBConnectionSelect

-- libDBGetCurrentConnection
--
-- Returns the current connection ID.
--
function libDBGetCurrentConnection
   return sDBID
end libDBGetCurrentConnection

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

-- libDBIsConnected
--
-- Checks if the current database connnection is open.
--
function libDBIsConnected
   get revOpenDatabases()
   return sDBID is among the items of it
end libDBIsConnected

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
   if the result is an integer then      
      switch revDatabaseType(sDBID)
         case "mysql"
            return libDBFetchAsText("SELECT LAST_INSERT_ID()")
            break
         case "postgresql"
            return libDBFetchAsText("SELECT currval(pg_get_serial_sequence('" & pTable & "', 'id'))")            
            break
         case "sqlite"
            return libDBFetchAsText("SELECT last_insert_rowid()")
            break
      end switch
   end if   
end libDBInsert

-- libDBUpdate
--
-- Updates rows in the given table identified by the id values.
-- Sets the fields defined in the data values.
--
command libDBUpdate pTable, pData, pIDs, pIDField
   local tQuery
   put "UPDATE" && pTable && "SET" into tQuery
   
   local tQueryParams, tParamCount
   put 1 into tParamCount   
   repeat for each key tKey in pData
      local tValue
      put pData[tKey] into tValue
      
      _libDBFormatValue tKey, tValue, tQueryParams, tParamCount
      put format(" %s = %s,", tKey, tValue) after tQuery
   end repeat
   delete the last char of tQuery
   
   if pIDs is not empty then
      if pIDField is empty then
         put "id" into pIDField
      end if
      
      _libDBFormatValue pIDField, pIDs, tQueryParams, tParamCount
      put format(" WHERE %s = %s", pIDField, pIDs) after tQuery
   end if
   
   libDBExecute tQuery, tQueryParams
   return the result
end libDBUpdate

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

-- libDBDeleteRow
--
-- Deletes the row with id pID from the given table.
--
command libDBDeleteRow pTable, pID, pField
   if pField is empty then
      put "id" into pField
   end if
   
   local tQuery
   put "DELETE FROM" && pTable && "WHERE" && pField && "= :1" into tQuery
   libDBExecute tQuery, pID
   return the result
end libDBDeleteRow

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

-- libDBFetchAsText
--
-- Query the database and return the result as text.
--
function libDBFetchAsText pQuery
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
   
   get revDataFromQuery(comma, return, sDBID, pQuery, "tQueryParams")
   if item 1 of it is "revdberr" then
      throw "libDBError: Error executing query." && it
   else
      return textDecode(it, "UTF-8")
   end if
end libDBFetchAsText

-- libDBFetchAsArray
--
-- Query the database and return the result as an array.
--
function libDBFetchAsArray pQuery
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
   
   local tCursor
   put revQueryDatabase(sDBID, pQuery, "tQueryParams") into tCursor
   if tCursor is not an integer then
      throw "libDBError: Error executing query." && tCursor
   end if   
   
   local tData
   put 1 into tCount
   repeat until revQueryIsAtEnd(tCursor)
      local tColumnNames
      put revDatabaseColumnNames(tCursor) into tColumnNames
      repeat for each item tName in tColumnNames
         local tColumnValue
         get revDatabaseColumnNamed(tCursor, tName, "tColumnValue")
         put textDecode(tColumnValue, "UTF-8") into tData[tCount][tName]
      end repeat
      revMoveToNextRecord tCursor
      
      add 1 to tCount
   end repeat
   revCloseCursor tCursor
   
   return tData   
end libDBFetchAsArray

function libDBNow pTime
   switch revDatabaseType(sDBID)
      case "mysql"
         if pTime is not empty then
            return "NOW()"
         else
            return "CURDATE()"
         end if
         break
      case "postgresql"
         if pTime is not empty then
            return "NOW()"
         else
            return "CURRENT_DATE"
         end if
         break
      case "sqlite"
         if pTime is not empty then
            return "datetime('now')"
         else
            return "date('now')"
         end if
         break
   end switch
end libDBNow
