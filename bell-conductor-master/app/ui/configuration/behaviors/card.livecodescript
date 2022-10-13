script "Configuration Card Behavior"
on preOpenCard
  local tRect

  if the environment is "mobile" then
    mobileSetAllowedOrientations "landscape right"
  end if
  put the rect of this stack into tRect
  put item 1 of tRect + 480 into item 3 of tRect
  put item 2 of tRect + 320 into item 4 of tRect
  set the rect of this stack to tRect

  set the text of field "NoteSpeed" to prefsGetPref("note speed")
  set the text of field "StartDelay" to prefsGetPref("start delay")
  set the text of field "NoteList" to prefsGetPref("notes")
  set the text of field "Tempo" to prefsGetPref("tempo")

  focus on nothing
end preOpenCard


on closeField
  switch the short name of the target
    case "NoteSpeed"
      prefsSetPref "note speed", word 1 to -1 of line 1 of the text of the target
      storeSet "note speed", prefsGetPref("note speed")
      break
    case "StartDelay"
      prefsSetPref "start delay", word 1 to -1 of line 1 of the text of the target
      storeSet "start delay", prefsGetPref("start delay")
      break
    default
      pass closeField
  end switch
end closeField


command uiLoadSong
  local tSongData

  answer file "Select song file"
  if it is empty then return empty

  # Line 1: Target temp x,y
  # Line 2: Default tempo
  # Line 3-n: Notes note,count

  put URL("file:" & it) into tSongData
  LoadSongData tSongData
end uiLoadSong


command LoadSongData pSongData
  set the text of field "LblTargetTempo" to "Target Tempo:" && line 1 of pSongData
  set the text of field "NoteList" to line 3 to -1 of pSongData

  set the itemDelimiter to "-"
  set the text of field "Tempo" to word 1 to -1 of line 2 of pSongData

  prefsSetPref "notes", the text of field "NoteList"
  prefsSetPref "tempo", the text of field "Tempo"
  storeSet "notes", prefsGetPref("notes")
  storeSet "tempo", prefsGetPref("tempo")
end LoadSongData


command uiPlaySong
  go stack "Playback" in window (the short name of this stack)
end uiPlaySong


command uiShowNotesInSong
  go stack "ShowNotes" in window (the short name of this stack)
end uiShowNotesInSong


command uiToggleFullscreen
  if the fullscreen of this stack then
    set the fullscreen of this stack to false
  else
    set the fullscreen of this stack to true
  end if
end uiToggleFullscreen
