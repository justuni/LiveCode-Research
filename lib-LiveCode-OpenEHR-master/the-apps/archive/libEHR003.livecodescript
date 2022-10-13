script "libEHR"

local sNum
Local sSessionID, sSubjectID, sEhrID
constant cRootURL = "https://ehrscape.code-4-health.org"
constant bossStack = "TestLibEHR"

--
function ehr.login pUserName, pPassword
    --
    -- needs to be set or verification error will occur
    libURLSetSSLVerification false
    --
    put cRootURL into tURL -- gets default url
    put empty into sSessionID -- initilizes session id variable
    put empty into tArgs -- want to post an empty body
    put tURL & "/rest/v1/session?username=" & pUsername & "&password=" & pPassword into tURL
    --
    post tArgs to tURL
    put it into tJson
    put the result into tResult
    --
    if bossStack = "TestLibEHR" then 
        if mobile() then put checkResponseFromServer( tJson, "mobile", urlresponse) into fld "lblSessionResults"
        else put checkResponseFromServer( tJson, libURLLastRHHeaders(), urlresponse) into fld "lblSessionResults"
    end if
    --
    if tResult is empty then
        put JsonImport(tJson) into tArray
        --
        -- check that a sessionId has been returned
        if "sessionId" is among the keys of tArray then
            put tArray["sessionId"] into tSessionID
            put tSessionID into sSessionID
            set the ehr["sessionId"] of stack bossStack to tSessionID
            set the ehr["sessionStatus"] of stack bossStack to "CONNECTED"
            set the ehr["ehrid"] of stack bossStack to empty
            return tSessionID -- successful
        else
            return "Error1:" && tJson -- not successful
        end if
    else
        if word 1 of tResult <> "error" then put "Error: " before tResult
        if char 1 of tResult = "e" then put "E" into char 1 of tResult
        return tResult -- not successful (bad URL, bad login credentials)
    end if
end ehr.login


function ehr.logout -- logs out of the ehr session
    put cRootURL into tURL
    put the ehr["sessionId"] of stack bossStack into sSessionId
    --
    put "Ehr-Session:" && sSessionID  into tHeaders 
    set httpHeaders to tHeaders
    --
    put tUrl & "/rest/v1/session?sessionId=" & sSessionId into tURL
    --
    delete URL tURL
    --
    -- on mobile the result is "not implemented", in the IDE it is empty
    -- on mobile, urlresponse is empty
    --
    put the result into tResult
    put the urlresponse into tJson
    --
    if not mobile() then
        if tJson <> empty then
            if "DELETE" is among the chars of tJson then
                put empty into sSessionId
                return "Disconnected" -- successfully logged out
            else
                return "Error: unable to disconnect from OpenEHR" -- unexpected data returned from server
            end if
        else
            return "Error: unable to delete Session Id" -- unable to connect to the server
        end if
    else
        if tResult = "not implemented" then 
            put empty into sSessionId
            return "Disconnected" -- successfully logged out
        else
            return "Error: no confirmation received from OpenEHR" --error message shown on mobile...
        end if
    end if
end ehr.logout


function ehr.sessionPing 
    put cRootURL into tURL
    put the ehr["sessionId"] of stack bossStack into sSessionId
    --
    put "Ehr-Session:" && sSessionID  into tHeaders 
    set httpHeaders to tHeaders
    
    put tURL & "/rest/v1/session" into tURL
    put "sessionId=" & sSessionId into tArgs
    --
    put tArgs into tURL
    put it into tJson
    put the result into tResult
    return tJson
end ehr.sessionPing


function ehr.getTemplateIds
    put "Ehr-Session:" && sSessionID  into tHeaders
    set httpHeaders to tHeaders
    put cRootURL into tURL
    put tURL & "/rest/v1/template" into tURL
    --
    get url tURL
    put it into tJson
    --
    if tJson <> empty then
        put JsonImport(tJson) into tArray
        if the keys of tArray = "templates" then
            repeat with i = 1 to the number of lines in the keys of tArray["templates"]
                put tArray["templates"][i]["templateId"] & tab & tArray["templates"][1]["createdOn"] & cr after tList
            end repeat
            delete char -1 of tList
            sort lines of tList
            set the ehr["templateIds"] of stack bossStack to tList
            return tList
          else
            return "Error:Unable to find valid Template IDs" -- unexpected data returned from server
        end if
    else
        if sSessionID <> empty then return "Error: unable to get Template IDs at this time" -- unable to connect to the server
        else return "Error: not logged in"
    end if
 end ehr.getTemplateIds


-- 01-05-2016 - at the moment this only works with 9999999000
function ehr.getEhrIdFromSubjectId pSubjectId
    set the ehr["ehrid"] of stack bossStack to empty
    put "Ehr-Session:" && sSessionID  into tHeaders --puts session id into header creation
    set httpHeaders to tHeaders -- sets the header abive
    put cRootURL into tURL -- gets default url
    put tURL & "/rest/v1/ehr/?subjectId=" & pSubjectId & "&subjectNamespace=uk.nhs.nhs_number" into tURL-- passes NHS number to url
    get url tURL
    put it into tJson
    --
    if bossStack = "TestLibEHR" then 
        if mobile() then put checkResponseFromServer( tJson, "mobile", urlresponse) into fld "lblEhrIdResults"
        else put checkResponseFromServer( tJson, libURLLastRHHeaders(), urlresponse) into fld "lblEhrIdResults"
    end if
    --
    if checkForJson(tJson) = "json" then
        if tJson <> empty then
            put JsonImport(tJson) into tArray
            if tArray["action"] = "RETRIEVE" then
                put tArray["ehrid"] into tEhrId
                set the ehr["ehrid"] of stack bossStack to tEhrId
                return tEhrId -- successfully got subject's EhrId
            else
                return "Error:Unable to find valid EhrId" -- unexpected data returned from server
            end if
        else
            if sSessionID <> empty then return "Error: unable to get an EhrId for this subject" -- unable to connect to the server
            else return "Error: not logged in"
        end if
    else if checkForJson(tJson) = "html" then return "Error: html error message returned from server"
    else if checkForJson(tJson) = "empty" then return "Error: no data returned from server"
end ehr.getEhrIdFromSubjectId


/*-----------------------------------------------------------------------------------------------------------------------
ehr.ehr.getCompositionId

Purpose: Gets the CompostionId of the subject using the subjects EhrId and the compostion name

Parameters:
-- pEhrId - the EhrId of the subject
-- pCompositionName - the 'name value' of the composition in question

Returns: the CompostionId of the named compostion for the subject
 -----------------------------------------------------------------------------------------------------------------------*/
function ehr.queryCompositionId pEhrId, pCompositionName
    set the ehr["compositionId"] of stack bossStack to empty
    set the ehr["start_time"] of stack bossStack to empty
    put the  ehr["aql.compositionId.fromSubjectId"] of stack bossStack into tAQL
    replace "{ehrid}" with pEhrId in tAQL
    replace "{compositionname}" with pCompositionName in tAQL
    put urlencode(tAQL) into tAQL
    --
    put cRootURL into tURL -- gets default url
    --
    put "Ehr-Session:" && sSessionID into tHeaders
    put cr &  "Content-Type: application/json" after tHeaders
    set httpHeaders to tHeaders -- sets the header abive
    --
    put tURL & "/rest/v1/query?aql=" & tAQL into tURL
    --
    get url tURL
    put it into tJson
    put the result into tResult
    --    
    if bossStack = "TestLibEHR" then 
        if mobile() then put checkResponseFromServer( tJson, "mobile", urlresponse) into fld "lblCompositionIDResults"
        else put checkResponseFromServer( tJson, libURLLastRHHeaders(), urlresponse) into fld "lblCompositionIDResults"
    end if
    --
    if checkForJson(tJson) = "json" then
        if tResult is empty then
            put JsonImport(tJson) into tArray
            if tArray["resultSet"] is not empty AND the len of tArray["resultSet"][1]["compositionId"] > 50 then
                put tArray["resultSet"][1]["compositionId"] into tCompositionId
                put tArray["resultSet"][1]["start_time"] into tStartTime
                set the ehr["compositionId"] of stack bossStack to tCompositionId
                set the ehr["start_time"] of stack bossStack to tStartTime
                --
                set itemdel to "::"
                set the ehr["domainName"] of stack bossStack to item 2 of tCompositionId
                --
                return tCompositionId -- successfully got the CompostionId
            else
                return "Error: no CompositionId returned from the server"
            end if
        else
            return "Error: CompositionId" && tResult
        end if
    else if checkForJson(tJson) = "html" then return "Error: html error message returned from server"
    else if checkForJson(tJson) = "empty" then return "Error: no data returned from server"
end ehr.queryCompositionId


function ehr.getCompostionData pCompositionId
    set the ehr["compositionDataReceived"] of stack bossStack to empty
    set the ehr["compositionJsonReceived"] of stack bossStack to empty
    put "Content-Type: application/json" & cr into tHeaders
    put "Ehr-Session:" && sSessionID after tHeaders
    set httpHeaders to tHeaders -- sets the header above
    put cRootURL into tURL -- gets default url
    put urlencode(pCompositionId) into pCompositionId
    --
    if mobile() then put "?format=FLAT" into tArg1
    else put "?format=FLAT HTTP/1.1" into tArg1
    --
    put tURL & "/rest/v1/composition/" & pCompositionId & tArg1 into tURL
    --
    --answer t1 & cr & t2
    get url tURL
    put it into tJson
    --
    if bossStack = "TestLibEHR" then 
        if mobile() then put checkResponseFromServer( tJson, "mobile", urlresponse) into fld "lblCompositionDataResults"
        else put checkResponseFromServer( tJson, libURLLastRHHeaders(), urlresponse) into fld "lblCompositionDataResults"
    end if
    --
    if checkForJson(tJson) = "json" then
        put JsonImport(tJson) into tArray
        if tArray["composition"] is not empty then
            set the ehr["compositionDataReceived"] of stack bossStack to tArray["composition"]
            set the ehr["compositionJsonReceived"] of stack bossStack to tJson
            put tName & cr & cr & the keys of tArray["composition"] into tCompositionDataReceived
            --
            if bossStack = "TestLibEHR" then
                put fld "fldCompositionName" into tTemplateName
                put the number of lines in the keys of tArray["composition"] into tNumOfKeys
                put tArray["composition"]["nursing_vital_signs_observations/composer|name"] into tName
                return tNumOfKeys && "elements of composition data received. The composer was" && tName
            else
                return  tArray["composition"]
            end if
        else
            return "Error: Unable to find valid Composition data" -- unexpected data returned from server
        end if
    else if checkForJson(tJson) = "html" then return "Error: html error message returned from server"
    else if checkForJson(tJson) = "empty" then return "Error: no data returned from server"
end ehr.getCompostionData


private function checkResponseFromServer pJson, pLastHeaders, pUrlResponse
    if pJson is not empty then
        if char 3 to 6 of pJson = "meta" then put "json" into tJson
        else if char 1 to 6 of pJson = "<html>" then put "html" into tJson
        else put "unknown" into tJson
    else
        put "empty" into tJson
    end if
    --
    if not mobile() then
        if pLastHeaders is not empty then put word 2 to -1 of line 1 of pLastHeaders into tLastHeaders
        else put "empty" into tLastHeaders
    end if
    --
    if pUrlResponse is not empty then
        if char 3 to 6 of pUrlResponse = "meta" then put "json" into tUrlResponse
        else if char 1 to 6 of pUrlResponse = "<html>" then put "html" into tUrlResponse
        else put "unknown" into tUrlResponse
    else
        put "empty" into tUrlResponse
    end if
    --
    if not mobile() then return "Data:" && tJson & cr & "Headers:" && tLastHeaders & cr & "UrlResponse:" && tUrlResponse
    else return "Data:" && tJson & cr & "UrlResponse:" && tUrlResponse
end checkResponseFromServer


private function checkForJson pData
    if pData is not empty then
        if char 3 to 6 of pData = "meta" then put "json" into tData
        else if char 1 to 6 of pData = "<html>" then put "html" into tData
        else put "unknown" into tData
    else
        put "empty" into tData
    end if
    return tData
end checkForJson


private function mobile
    return the environment = "mobile"
end mobile
