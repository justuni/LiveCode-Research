script "libehr"

local sNum
Local sSessionID, sSubjectID, sEhrID
constant basicURL = "https://rest.ehrscape.com/rest/v1"

--
function ehr.login pUserName, pPassword
    --
    -- needs to be set or verification error will occur
    libURLSetSSLVerification false
    --
    put basicURL into tURL -- gets default url
    put empty into sSessionID -- initilizes session id variable
    put empty into tArgs -- want to post an empty body
    put tURL & "/session?username=" & pUsername & "&password=" & pPassword into tURL
    --answer tURL
    post tArgs to tURL
    put it into tJson
    if the result is empty then
        return tJson
        --put  JSONtoArray(tJson) into tArray
        --put tArray["sessionId"] into sSessionID
        --return tArray["sessionId"] -- successful login
    else
        return "Error: " & tJson -- not successful
    end if
end ehr.login


function ehr.logout -- logs out of the ehr session
   put basicURL into tURL
   put tUrl & "/session?sessionId=" & sSessionID into tURL
   delete URL tURL
   put the urlresponse into tData
   return tData
   --put jsontoArray(tData) into tArray
   --if tArray["action"] is "DELETE" then
      --return true -- if successful
   --else
      --return false --if not successful (e.g. if already logged out)
   --end if
end ehr.logout


on launchit
     answer "thunderbirds are go"
end launchit

on doagain
   answer "yeeha"
end doagain

on andagain
     answer "repeat"
end andagain

on justgo pItem
   --put 22 * 10 into tNum
   put addup(1234) into tNum
      put "is growing!" into tString
   answer tNum && pItem && tString
end justgo

on andanother
   answer "do it again sam"
end andanother

function addup pNum
   if sNum is empty then put 22 into sNum
   put pNum * sNum into sNum
   return sNum
end addup

function jam pFilling
   return basicURL && pFilling
end jam
