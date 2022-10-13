function CSVToTab pData, pOldLineDelim, pOldItemDelim, pNewCR, pNewTAB
   -- v 3 -> 4   put back in replace TAB with pNewTAB in 'passedquote'
   -- v 4 -> 5   put in the two replace statements in the trailing empty case
      -- fill in defaults
      if pOldLineDelim is empty then put CR into pOldLineDelim
      if pOldItemDelim is empty then put COMMA into pOldItemDelim
      if pNewCR is empty then put numtochar(11) into pNewCR   -- Use <VT> for quoted CRs
      if pNewTAB is empty then put numtochar(29) into pNewTAB      -- Use <GS> (group separator) for quoted TABs

      local tNuData                         -- contains tabbed copy of data

      local tStatus, theInsideStringSoFar

      -- Normalize line endings: REMOVED
      -- Will normaly be correct already, only binfile: or similar chould make this necessary
      -- and that exceptional case should be the caller's responsibility

      put "outside" into tStatus
      set the itemdel to quote
      repeat for each item k in pData
            -- put tStatus && k & CR after msg
            switch tStatus

                  case "inside"
                        put k after theInsideStringSoFar
                        put "passedquote" into tStatus
                        next repeat

                  case "passedquote"
                        -- decide if it was a duplicated escapedQuote or a closing quote
                        if k is empty then   -- it's a duplicated quote
                              put quote after theInsideStringSoFar
                              put "inside" into tStatus
                              next repeat
                        end if
                        -- not empty - so we remain inside the cell, though we have left the quoted section
                        -- NB this allows for quoted sub-strings within the cell content !!
                        replace pOldLineDelim with pNewCR in theInsideStringSoFar
                        replace TAB with pNewTAB in theInsideStringSoFar
                        put theInsideStringSoFar after tNuData

                  case "outside"
                        replace pOldItemDelim with TAB in k
                        -- and deal with the "empty trailing item" issue in Livecode
                        replace (pNewTAB & pOldLineDelim) with pNewTAB & pNewTAB & CR in k
                        put k after tNuData
                        put "inside" into tStatus
                        put empty into theInsideStringSoFar
                        next repeat
                  default
                        put "defaulted"
                        break
            end switch
      end repeat

      -- and finally deal with the trailing item isse in input data
      -- i.e. the very last char is a quote, so there is no trigger to flush the
      --      last item
      if the last char of pData = quote then
                  replace pOldLineDelim with pNewCR in theInsideStringSoFar
                  replace TAB with pNewTAB in theInsideStringSoFar
            put theInsideStringSoFar after tNuData
      end if

      return tNuData
end CSVToTab
