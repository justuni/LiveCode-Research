# csvToArray  
From Peter Brigham, totally separate code (as of today), for putting csv into an array.  

`get tabTableToArray(pTable{,withHeaders})`  
Returns a two-dimensional array from a csv-encoded container  
• pTable is the csv-encoded data  
• withHeaders is a boolean (default false).  If true, then first line is assumed to be column titles, and first column of each line is assumed to be row titles.  Headers are stored in tArray["_row_names_"] and t_array["_column_names_"].  Both are comma-delimited lists.  If withHeaders is false then array is tArray[n][i] where n=row and i=column.  


`get arrayToTable(tArray)`  
Returns a tab-delimited table from a two-dimensional array  
• tArray is the 2D array.  If it is formatted with row and column names, e.g. tArray[tRowName][tColName] then tArray["_column_names_"] should contain a comma-delimited list of column names to be put on the top of the resulting container, and tArray["_row_names_"] should contain a comme-delimited list of row names, to be put in the first column of each row of the resulting container.  If these keys are missing, then it is assumed that the format is tArray[tRowNumber][tColumnNumber]


# csvToTab
Originally a project by Alex Tweedly to improve Richard's code, we eventually put it in the community...

`get CSVToTab (pData {,pColDelim})`  
Returns a tab-delimited container from a csv-encoded container.  
• pData is the csv-encoded data  
• pCodeDelim is the initial column delimiter (default comma)  


#testFiles
Corner and edge cases built by Mikey and others, probably, for all the ways that CSV is inconsistent, but we have to deal with it, anyway.
