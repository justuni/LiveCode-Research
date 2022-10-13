# from Peter M. Brigham (pmbrig@gmail.com), added to the "How" list on 6/24/16


function tabTableToArray pTable, withHeaders
   -- returns a 2-dimensional array from a tab-delimited table
   -- if withHeaders = true then first line is treated as column titles
   --    and first column is treated as row titles,
   --    data is stored as tArray[rowName][colName]
   --    headers are stored in tArray["_row_names_"] and tArray["_column_names_"]
   --       as comma-delim lists
   -- if withHeaders = false (default) then array is
   --    tArray[n][i], where n = rowNumber, i = columnNumber
   -- requires arrayToTabTable()
   --    which is the inverse function

   if tab is not in pTable then return empty
   if withHeaders = empty then put false into withHeaders
   set the itemdelimiter to tab
   if withHeaders then
      put line 1 of pTable into colHdrsList
      delete line 1 of pTable
      delete char 1 of colHdrsList
      put (the number of items of colHdrsList) into nbrItems -- for debugging
      repeat for each line tLine in pTable
         put item 1 of tLine into thisRowHdr
         put thisRowHdr & comma after rowHdrs
         delete item 1 of tLine
         repeat with i = 1 to nbrItems
            put item i of tLine into tArray[thisRowHdr][item i of colHdrsList]
         end repeat
      end repeat
      delete char -1 of rowHdrs
      put rowHdrs into tArray["_row_names_"]
      replace tab with comma in colHdrsList
      put colHdrsList into tArray["_column_names_"]
   else
      -- first get the max number of items in the lines
      -- in case of empty trailing items in some lines
      put 0 into maxItems
      repeat for each line tLine in pTable
         put max(maxItems,the number of items of tLine) into maxItems
      end repeat
      repeat with n = 1 to the number of lines of pTable
         repeat with i = 1 to maxItems
            put item i of line n of pTable into tArray[n][i]
         end repeat
      end repeat
   end if
   return tArray
end tabTableToArray



function arrayToTabTable tArray
   -- returns a tab-delimited table from a two-dimensional array
   --    eg, one created by tabTableToArray()
   -- if the array format is tArray[tRowName][tColName]
   --    then tArray["_column_names_"] should contain a comma-delim list
   --       of column names
   --    and tArray["_row_names_"] should contain a comma-delim list of row names
   -- if these special keys are empty then assumes that the array format is
   --    tArray[tRowNbr][tColNbr]
   -- requires tabTableToArray()
   --    which is the inverse function

   put the keys of tArray into tKeys
   put the number of lines of tKeys into nbrLines
   if nbrLines = 0 then return empty -- not an array
   filter tKeys without "_column_names_"
   filter tKeys without "_row_names_"
   put the number of lines of the keys of tArray[line 1 of tKeys] into nbrCols
   if nbrCols = 0 then return empty -- not a 2-dimensional array
   set the itemdelimiter to tab
   put tArray["_column_names_"] into colNames
   if colNames <> empty then
      -- column headers and row names are stored.
      -- first row must be column headers, first col must be row names
      put tArray["_row_names_"] into rowNames
      replace comma with tab in colNames
      replace comma with cr in rowNames
      put tab before colNames
      put colNames into tTable
      repeat for each line tRowName in rowNames
         put tRowName into tableRow
         repeat for each item tCol in colNames
            if tCol = empty then next repeat
            if tCol is not among the lines of the keys of tArray[tRowName] \
                  then next repeat
            put tArray[tRowName][tCol] into tElement
            put tab & tElement after tableRow
         end repeat
         put cr & tableRow after tTable
      end repeat
   else
      repeat with n = 1 to nbrLines
         repeat with i = 1 to nbrCols
            put tArray[n][i] into item i of line n of tTable
         end repeat
      end repeat
   end if
   return tTable
end arrayToTabTable
