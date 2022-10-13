script "Playback Card Behavior"

constant kMilliPerMinute = 60000
constant kFlashRectIncrease = "10"

local sDelayForWholeNote
local sSongA, sMsgId
local sStartY,sStartX
local sNoteSpeed


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
  InitializeTimers
  GenerateSong

  if storeGet("start delay") is an integer then
    send "PlaySong" to me in storeGet("start delay") milliseconds
  else
    PlaySong
  end if
end openCard


on closeCard
  CancelMessage "PlaySong"
  CancelPlayback
end closeCard


on mouseDoubleDown
  if the target is me and the environment is "development" then
    go stack "Configuration" in window (the short name of this stack)
  end if
end mouseDoubleDown


command InitializeTimers
  local theTempo

  # 60,000 ms (1 minute) / Tempo (BPM) = Delay Time in ms for quarter-note beats
  # (60,000 ms (1 minute) / Tempo (BPM)) * 4 = delay time for a whole note
  put storeGet("tempo") into theTempo
  put (kMilliPerMinute / theTempo) * 4 into sDelayForWholeNote
  put storeGet("note speed") into sNoteSpeed

  put the left of group "NoteStream" - the width of graphic 1 of group "NoteTemplates" of this card of stack "NoteTemplates" into sStartX
  put item 2 of the loc of group "NoteStream" into sStartY
  put empty into sSongA
end InitializeTimers


command CancelPlayback
  cancel sMsgId
  aeStopMoving "all"
  aeStopChangingRect "all"
  CancelMessage "_aeFadeOut"
  ResetNoteStream
end CancelPlayback


command GenerateSong
  local tList, tLine
  local tNote, tCount, i
  local tRepeatCounter = 1

  put storeGet("notes") into tList
  repeat for each line tLine in tList
    if tLine is empty then next repeat

    put item 1 of tLine into tNote
    put item 2 of tLine into tCount

    switch tNote
      case "REPEAT"
        repeat with j = tRepeatCounter to the number of elements of sSongA
          add 1 to i
          put sSongA[j] into sSongA[i]
        end repeat
        put i + 1 into tRepeatCounter
        break
      default
        if tCount is not a number then next repeat

        add 1 to i
        put sDelayForWholeNote * tCount into sSongA[i]["delay"]
        put tNote into sSongA[i]["note"]
    end switch
  end repeat

  -- put printArray(sSongA)
end GenerateSong


command PlaySong
  if sSongA[1] is an array then
    PlayNote 1
  end if
end PlaySong


command SongIsDone

end SongIsDone


command PlayNote pNoteIndex
  local tNextIndex, tError

  lock screen
  lock messages

  put pNoteIndex + 1 into tNextIndex

  switch sSongA[pNoteIndex]["note"]
    case "PAUSE"
      break
    default
      copy graphic sSongA[pNoteIndex]["note"] of group "NoteTemplates" of this card of stack "NoteTemplates" to group "NoteStream"
      put the long id of it into sSongA[pNoteIndex]["control"]

      set the layermode of it to "dynamic"
      set the loc of it to sStartX, sStartY
      unlock messages
      unlock screen

      aeMoveTo sSongA[pNoteIndex]["control"], \
      item 1 of the loc of control "PlayNoteLine", item 2 of the loc of it, sNoteSpeed
      put the result into tError
      if tError begins with "error:" then
        answer error tError
      exit to top
      end if
  end switch

  if sSongA[tNextIndex] is an array then
    send "PlayNote tNextIndex" to me in sSongA[pNoteIndex]["delay"] milliseconds
    put the result into sMsgId
  else
    local i, foundANote = "false"

    # Flag last note so that we know when song ends
    repeat with i = pNoteIndex down to 1
      if there is a sSongA[i]["control"] then
        set the uIsLastNote of sSongA[i]["control"] to true
        put true into foundANote
        exit repeat
      end if
    end repeat

    # No notes have been created so just dispatch message
    if not foundANote then
      dispatch "SongIsDone"
    end if
  end if
end PlayNote


command ResetNoteStream
  lock messages
  repeat with i = the number of controls of group "NoteStream" down to 1
    delete control i of group "NoteStream"
  end repeat
  unlock messages
end ResetNoteStream


command DeleteNote pControl
  local songIsDone
  # Is this the last note?
  put the uIsLastNote of pControl into songIsDone
  set the aeListenForCollisionsWith of pControl to empty
  delete pControl

  if songIsDone then
   dispatch "SongIsDone"
  end if
end DeleteNote


on aeMoveDone
  local tRect
  put the rect of the target into tRect
  subtract kFlashRectIncrease from item 1 of tRect
  subtract kFlashRectIncrease from item 2 of tRect
  add kFlashRectIncrease to item 3 of tRect
  add kFlashRectIncrease to item 4 of tRect

  aeChangeRect the long id of the target, item 1 of tRect, item 2 of tRect, item 3 of tRect, item 4 of tRect,  \
        200, "out"
  aeFadeOut the long id of the target,200
end aeMoveDone


command aeChangeRectDone
end aeChangeRectDone


command aeFadeDone
  get the long id of the target
  send "DeleteNote it" to me in 0 milliseconds
end aeFadeDone


command uiCancelPlayback
  CancelPlayback
end uiCancelPlayback


command uiStartOver
  PlaySong
end uiStartOver
