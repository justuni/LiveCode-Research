script "Shared Handlers"
/**
Summary: Cancels all pending messages for pMsg.

Description:
If you pass in a target object then only messages being sent to that object will be canceled.
*/
command CancelMessage pMsg, pTargetObject
  local tString, tMessage, tMessages

  put "," & pMsg & "," into tString
  if pTargetObject is not empty then put pTargetObject after tString

  repeat until tString is not in the pendingMessages
    put the pendingMessages into tMessages
    filter tMessages with "*" & tString & "*"
    repeat for each line tMessage in tMessages
      cancel item 1 of tMessage
    end repeat
  end repeat
end CancelMessage


function PrintArray @pArray, pDimension, pFullData
  local tKeys, tKey, tText

  if pDimension is empty then put 0 into pDimension

  put the keys of pArray into tKeys
  sort tKeys numeric

  repeat for each line tKey in tKeys
    if pArray[tKey] is an array then
    put _printCharXTimes(space, pDimension * 5) & tKey & cr after tText
      put PrintArray(pArray[tKey], pDimension + 1, pFullData) after tText
    else
      if pFullData then
        put _printCharXTimes(space, pDimension * 5) &  tKey & ":" && pArray[tKey] & cr after tText
      else
        put _printCharXTimes(space, pDimension * 5) &  tKey & ":" && line 1 of pArray[tKey] & cr after tText
      end if
    end if
  end repeat

  return tText
end PrintArray


private function _printCharXTimes pChar, pTimes
  local tStr

  repeat with i = 1 to pTimes
    put pChar after tStr
  end repeat
  return tStr
end _printCharXTimes
