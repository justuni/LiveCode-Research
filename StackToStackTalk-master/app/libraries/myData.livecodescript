script "myData"
local sData

function getData
  return sData
end getData

command setData pValue
  put pValue into sData
end setData
