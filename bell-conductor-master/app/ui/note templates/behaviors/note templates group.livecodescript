script "Note Templates Group Behavior"
on mouseMove
  if the mousecontrol is not empty then
    set the text of field "NoteName" to the short name of the mousecontrol
  else
    set the text of field "NoteName" to empty
  end if
end mouseMove


on mouseDoubleUp pBtnNum
  if pBtnNum is 1 then
    if the mouseControl is not empty then
      local tTarget

      put the long id of the mouseControl into tTarget
      answer color with the backgroundcolor of tTarget
      if it is not empty then
        set the backgroundcolor of tTarget to it
      end if
    end if
  end if
end mouseDoubleUp
