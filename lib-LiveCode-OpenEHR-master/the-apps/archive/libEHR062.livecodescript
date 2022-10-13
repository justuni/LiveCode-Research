script "libEHR"

/*-----------------------------------------------------------------------------------------------------------------------

Title:
libEHR


Version:
0.6.2


Release Date:
03-08-2016


Licensing:
**include something here about which open source licence to use**


Description:
**include something here on background and purpose of the library**


Contributors:
Dave Kilroy - Application Insight Ltd
Ian McNicoll - FreshEHR Ltd
Code4Health
Apperta


Where to get it from:
**download URL (on github)
Returns: the CompostionId of the named compostion for the subject
 -----------------------------------------------------------------------------------------------------------------------*/


local sNum
Local sSessionID, sSubjectID, sEhrID
constant bossStack = "testLibEHR"
constant libEHRversion = 0.6.2



-----------------------------------------------------------------------------------------------------------
-- STUFF RELATED TO LOGIN, LOGOUT AND SESSIONS
-----------------------------------------------------------------------------------------------------------

on __LOGIN_AND_SESSIONS__
end __LOGIN_AND_SESSIONS__


--
function ehr.login pUserName, pPassword
   -- needs to be set or verification error will occur
   libURLSetSSLVerification false
   --
   put the ehr["rootURL"] of stack bossStack into tURL
   --
   --ZZZ
   if tURL is empty then put "https://ehrscape.code-4-health.org" into tURL
   --
   put empty into sSessionID -- initilizes session id variable
   put empty into tArgs -- want to post an empty body
   put tURL & "/rest/v1/session?username=" & pUsername & "&password=" & pPassword into tURL
   --
   post tArgs to tURL
   put it into tJson
   put the result into tResult
   --
   if bossStack = "testLibEHR" then
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
   put the ehr["rootURL"] of stack bossStack into tURL
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
   put the ehr["rootURL"] of stack bossStack into tURL -- gets default url
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




-----------------------------------------------------------------------------------------------------------
--  STUFF RELATED TO EHR IDs (Electronic Health Record Ids)
-----------------------------------------------------------------------------------------------------------

on __EHRID__
end __EHRID__

-- 01-05-2016 - at the moment this only works with 9999999000
function ehr.getEhrIdFromSubjectId pSubjectId
   set the ehr["ehrid"] of stack bossStack to empty
   put "Ehr-Session:" && sSessionID  into tHeaders --puts session id into header creation
   set httpHeaders to tHeaders -- sets the header abive
   put the ehr["rootURL"] of stack bossStack into tURL
   put tURL & "/rest/v1/ehr/?subjectId=" & pSubjectId & "&subjectNamespace=uk.nhs.nhs_number" into tURL-- passes NHS number to url
   get url tURL
   put it into tJson
   --
   if bossStack = "testLibEHR" then
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




-----------------------------------------------------------------------------------------------------------
--  STUFF RELATED TO TEMPLATES (web templates, example data etc)
-----------------------------------------------------------------------------------------------------------

on __TEMPLATES__
end __TEMPLATES__

function ehr.getTemplateIds
   put "Ehr-Session:" && sSessionID  into tHeaders
   set httpHeaders to tHeaders
   put the ehr["rootURL"] of stack bossStack into tURL
   put tURL & "/rest/v1/template/" into tURL
   --
   get url tURL
   put it into tJson
   --
   if tJson <> empty then
      put JsonImport(tJson) into tArray
      if the keys of tArray = "templates" then
         repeat with i = 1 to the number of lines in the keys of tArray["templates"]
            put tArray["templates"][i]["templateId"] & tab & "nodeId" & tab & "compositionName" & cr after tList
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


function ehr.getWebTemplate pTemplateId
   put pcEncode(pTemplateId) into pTemplateId
   set the ehr["webTemplate"] of stack bossStack to empty
   put "Content-Type: application/json" & cr into tHeaders
   put "Ehr-Session:" && sSessionID after tHeaders
   set httpHeaders to tHeaders
   put the ehr["rootURL"] of stack bossStack into tURL
   --
   if mobile() then put "?format=FLAT" into tArg1
   else put "?format=FLAT HTTP/1.1" into tArg1
   put "&defaultLanguage=en" into tArg2
   --
   put tURL & "/rest/v1/template/" & pTemplateId & tArg1 & tArg2 into tURL
   --
   get url tURL
   put it into tJson
   set the ehr["webTemplate"] of stack bossStack to tJson
   --
   if bossStack = "testLibEHR" then
      if mobile() then put checkResponseFromServer( tJson, "mobile", urlresponse) into fld "lblTemplateNameResults"
      else put checkResponseFromServer( tJson, libURLLastRHHeaders(), urlresponse) into fld "lblTemplateNameResults"
   end if
   --
   put checkForJson(tJson) into tJsonCheck
   if tJsonCheck = "json" then
      return tJson
   else if tJsonCheck = "html" then return "Error: html error message returned from server"
   else if tJsonCheck = "empty" then return "Error: no data returned from server"
   else return tJson
end ehr.getWebTemplate


function ehr.getTemplateExampleData pTemplateId
   put pcEncode(pTemplateId) into pTemplateId
   set the ehr["templateExampleData"] of stack bossStack to empty
   put "Content-Type: application/json" & cr into tHeaders
   put "Ehr-Session:" && sSessionID after tHeaders
   set httpHeaders to tHeaders
   put the ehr["rootURL"] of stack bossStack into tURL
   --
   if mobile() then put "?format=FLAT" into tArg1
   else put "?format=FLAT HTTP/1.1" into tArg1
   put "&exampleFilter=INPUT" into tArg2
   --
   put tURL & "/rest/v1/template/" & pTemplateId & "/example" & tArg1 & tArg2 into tURL
   --
   get url tURL
   put it into tJson
   set the ehr["templateExampleData"] of stack bossStack to tJson
   --
   if bossStack = "testLibEHR" then
      if mobile() then put checkResponseFromServer( tJson, "mobile", urlresponse) into fld "lblExampleCompDataResults"
      else put checkResponseFromServer( tJson, libURLLastRHHeaders(), urlresponse) into fld "lblExampleCompDataResults"
   end if
   --
   put checkForJson(tJson) into tJsonCheck
   if tJsonCheck = "json" then
      return tJson
   else if tJsonCheck = "html" then return "Error: html error message returned from server"
   else if tJsonCheck = "empty" then return "Error: no data returned from server"
   else return tJson
end ehr.getTemplateExampleData




-----------------------------------------------------------------------------------------------------------
-- STUFF RELATED TO COMPOSITIONS
-----------------------------------------------------------------------------------------------------------

on __COMPOSITIONS__
end __COMPOSITIONS__

/*-----------------------------------------------------------------------------------------------------------------------
ehr.ehr.getCompositionId

Purpose: Gets the CompostionId of the subject using the subjects EhrId and the compostion name

Parameters:
-- pEhrId - the EhrId of the subject
-- pCompositionName - the 'name value' of the composition in question

Returns: the CompostionId of the named compostion for the subject
 -----------------------------------------------------------------------------------------------------------------------*/
function ehr.queryCompositionId pEhrId, pNodeId, pCompositionName
   set the ehr["compositionId"] of stack bossStack to empty
   set the ehr["start_time"] of stack bossStack to empty
   put the  ehr["aql.compositionId.fromSubjectId"] of stack bossStack into tAQL
   replace "{ehrid}" with pEhrId in tAQL
   replace "{nodeId}" with pNodeId in tAQL
   replace "{compositionname}" with pCompositionName in tAQL
   put pcEncode(tAQL) into tAQL
   --
   put the ehr["rootURL"] of stack bossStack into tURL
   --
   put "Ehr-Session:" && sSessionID into tHeaders
   put cr &  "Content-Type: application/json" after tHeaders
   set httpHeaders to tHeaders
   --
   put tURL & "/rest/v1/query?aql=" & tAQL into tURL
   replace "+" with "%20" in tURL
   --
   get url tURL
   put it into tJson
   put the result into tResult
   --
   if bossStack = "testLibEHR" then
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


function ehr.getCompostionData pCompositionId,pCompositionName
   set the ehr["compositionDataReceived"] of stack bossStack to empty
   set the ehr["compositionJsonReceived"] of stack bossStack to empty
   put "Content-Type: application/json" & cr into tHeaders
   put "Ehr-Session:" && sSessionID after tHeaders
   set httpHeaders to tHeaders
   put the ehr["rootURL"] of stack bossStack into tURL
   put pcEncode(pCompositionId) into pCompositionId
   --
   if mobile() then put "?format=FLAT" into tArg1
   else put "?format=FLAT HTTP/1.1" into tArg1
   --
   put tURL & "/rest/v1/composition/" & pCompositionId & tArg1 into tURL
   --
   get url tURL
   put it into tJson
   --
   if bossStack = "testLibEHR" then
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
         if bossStack = "testLibEHR" then
            put fld "fldCompositionName" into tTemplateName
            put the number of lines in the keys of tArray["composition"] into tNumOfKeys
            --
            put toLower(pCompositionName) into tCompositionName
            replace space with "_" in tCompositionName
            put "/composer|name" after tCompositionName
            put tArray["composition"][tCompositionName] into tName
            return tNumOfKeys && "elements of data received. The composer was" && tName
         else
            return  tArray["composition"]
         end if
      else
         return "Error: Unable to find valid Composition data" -- unexpected data returned from server
      end if
   else if checkForJson(tJson) = "html" then return "Error: html error message returned from server"
   else if checkForJson(tJson) = "empty" then return "Error: no data returned from server"
end ehr.getCompostionData

--pTemplateId = templateId
--pCompositionData = tData
--compositionId = compositionId
function ehr.updateComposition pTemplateId, pCompositionId, pCompositionData
   put pcEncode(pTemplateId) into pTemplateId
   put pcEncode(pCompositionId) into pCompositionId
   
   --bug
   --apparently it doesn't like "FLAT HTTP/1.1" in the IDE - need to confirm this in a standalone
   --   if mobile() then put "FLAT" into tFormat
   --   else put "FLAT HTTP/1.1" into tFormat
   put "FLAT" into tFormat
   --
   put the ehr["rootURL"] of stack bossStack into tURL
   put tURL &  "/rest/v1/composition/" & pCompositionId &"?format=" & tFormat & "&templateId=" & pTemplateId into tURL
   --put pcEncode(tURL) into tURL
   put  "Ehr-Session:" && sSessionID &  cr  after tHeaders
   put  "Content-Type: application/json" &  cr  after tHeaders
   set httpHeaders to tHeaders
   put pCompositionData into url tUrl
   put url tUrl into tData
   --
   put the result into tResult
   put it into zz
   put libURLLastRHHeaders() & cr & "xxxxxxxxxxxxxx" & cr & "result" && tResult & cr & "it" && zz & cr & "xxxxxxxxxxxxxx" --& cr & tData
   return tData
   
end ehr.updateComposition



-----------------------------------------------------------------------------------------------------------
--  MISCELEANOUS STUFF
-----------------------------------------------------------------------------------------------------------

on __MISCELLANEOUS__
end __MISCELLANEOUS__

function ehr.version
   return libEHRversion
end ehr.version


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
      else if char 11 to 13 of pData = "404" then
         put offset("developerMessage", pData) into tStart
         put char (tStart + 19) to (tStart + 109) of pData into tData
      else put "unknown" into tData
   else
      put "empty" into tData
   end if
   return tData
end checkForJson


private function mobile
    return the environment = "mobile"
end mobile

-- this function from Niel Rogers
function pcEncode pString
   put pString into tUnencoded
   put urlencode(tUnencoded) into tEncoded
   replace "%0D" with "%20" in tEncoded
   replace "%0A" with "%20" in tEncoded
   replace "+" with "%20" in tEncoded
   replace "*" with "%2A" in tEncoded
   return tEncoded
end pcEncode


function saveFile pFile, pData
   if mobile() then
      put specialFolderPath("documents") & "/ehrdata" into tDestinationFolder
   else
      put specialFolderPath("resources") & "/ehrdata" into tDestinationFolder
   end if
   if there is not a folder tDestinationFolder then create folder tDestinationFolder
   put tDestinationFolder & slash & pFile into tPath
   put pData into URL("binfile:" & tPath)
   --
   if the result is empty then
      if there is a file tPath then
         return " and saved"
      else
         return " but not saved"
      else
         return " but not saved"
      end if
   end if
end saveFile


function getFile pFile
   if mobile() then
      put specialFolderPath("documents") & "/ehrdata" into tSourceFolder
   else
      put specialFolderPath("resources") & "/ehrdata" into tSourceFolder
   end if
   if there is not a folder tSourceFolder then create folder tSourceFolder
   put tSourceFolder & slash & pFile into tPath
   --
   if there is a file tPath then
      put URL("binfile:" & tPath) into tData
      --
      if the result is empty then return tData
      else return "Error: unable to get file " & pFile
   end if
end getFile
