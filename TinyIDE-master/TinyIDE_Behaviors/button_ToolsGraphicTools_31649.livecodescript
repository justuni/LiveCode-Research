script "button_ToolsGraphicTools_31649"
global gStackName
on mouseUp
   if the hilite of me is true then
      set the cpToolsGraphicTools of this stack to "true"
   else
      set the cpToolsGraphicTools of this stack to "false"
   end if
end mouseUp
