script "Show Notes Card Behavior"
on preOpenCard
  local tRect

  if the environment is "mobile" then
    mobileSetAllowedOrientations "landscape right"
  end if

  put the rect of this stack into tRect
  put item 1 of tRect + 480 into item 3 of tRect
  put item 2 of tRect + 320 into item 4 of tRect
  set the rect of this stack to tRect
end preOpenCard


on openCard
  GenerateNotes
end openCard


on closeCard
  ResetNotes
end closeCard


on mouseDoubleDown
  if the target is me and the environment is "development" then
    uiReturnToConfig
  end if
end mouseDoubleDown


command uiReturnToConfig
  go stack "Configuration" in window (the short name of this stack)
end uiReturnToConfig


command GenerateNotes
  local tList, tLine
  local tNote, tCount, tNotesA

  put storeGet("notes") into tList
  repeat for each line tLine in tList
    if tLine is empty then next repeat

    put item 1 of tLine into tNote
    put item 2 of tLine into tCount

    switch tNote
      case "REPEAT"
        break
      default
        if tCount is not a number then next repeat

        put empty into tNotesA[tNote]
    end switch
  end repeat

  local tNotes, tLoc

  put the keys of tNotesA into tNotes
  sort lines of tNotes ascending

  put "20,20" into tLoc
  repeat for each line tNote in tNotes
    copy graphic tNote of group "NoteTemplates" of this card of stack "NoteTemplates" to group "Notes"
    set the showname of it to true
    set the topleft of it to tLoc
    put the right of it + 20 into item 1 of tLoc

    if item 1 of tLoc > the right of me - 20 then
      put 20 into item 1 of tLoc
      put the bottom of it + 20 into item 2 of tLoc
      set the topleft of it to tLoc
      put the right of it + 20 into item 1 of tLoc
    end if
  end repeat
end GenerateNotes


command ResetNotes
  lock messages
  repeat with i = the number of controls of group "Notes" down to 1
    delete control i of group "Notes"
  end repeat
  unlock messages
end ResetNotes
