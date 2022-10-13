script "behavior_ViewScriptEditorSVG"
--> MetaData
-
license: GPLv3
name: behavior_ViewScriptEditorSVG
type: behavior
version: 0.2


--> Events
-
on resizeControl
   resize
end resizeControl


--> Panes
-
command resize
   set the rect of control 1 of me to the rect of me
end resize


--> Props
-
getprop svg_File svgFile
   put the svg_File of _svgView() into svgFile
   return svgFile
end svg_File

setprop svg_File [isFluid] svgFile
   set the svg_File [isFluid] of _svgView() to svgFile
   put the result into someHtml
   return someHtml
end svg_File


--> Objects
-
private function _svgView
   return the long id of control 1 of me
end _svgView
