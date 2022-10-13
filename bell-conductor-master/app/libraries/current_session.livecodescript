script "Current Session"
local sStoreA


function storeGet pProp
  return sStoreA[pProp]
end storeGet


command storeSet pProp, pValue
  put pValue into sStoreA[pProp]
end storeSet
