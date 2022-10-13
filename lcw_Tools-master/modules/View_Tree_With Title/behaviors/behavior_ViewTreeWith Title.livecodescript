script "behavior_ViewTreeWith Title"
--> MetaData
-
author: David Bovill
copyright: David Bovill
license: GPLv3
name: behavior_ViewTreeWith Title
type: view behavior
version: 0.1

/*
View help text...
*/


--> Events
-
on resizeControl
    if the long id of target = the long id of me is false then pass resizeControl
    LayoutControl the rect of me
end resizeControl


--> Menu | Props
-
-- getprop menu_Target [targetObject]
   set the itemDelimiter to "|"
   switch
      case targetObject contains "View|Tree|"
         return the tree_Field of me
      case targetObject contains "View|Title|"
         return the title_View of me
      default
         pass menu_Target
   end switch
end menu_Target

getprop menu_Title
   if the long id of me is not the long id of the target then pass menu_Title
   return the menu_Title of the title_View of me
end menu_Title

setprop menu_Title mTitle
   if the long id of me is not the long id of the target then pass menu_Title
   set the menu_Title of the title_View of me to mTitle
end menu_Title


--> Tree
-
setprop tree_Display [displayInfo] someOutline
   if the long id of the target is not the long id of me then pass tree_Display
   
   put item 1 of displayInfo into treeTitle
   put item 2 of displayInfo into expansionLevel
   
   lock screen
   if treeTitle is not empty then set the title_Text of me to treeTitle
   set the tree_Outline [expansionLevel] of me to someOutline
   unlock screen
   return true
end tree_Display

getprop tree_Array
   if the long id of the target is not the long id of me then pass tree_Array
   return the tree_Array of the tree_Field of me
end tree_Array

setprop tree_Array [pLevel] someArray
   if the long id of the target is not the long id of me then pass tree_Array
   set the tree_Array [pLevel] of the tree_Field of me to someArray
   return the result
end tree_Array

getprop tree_Outline
   if the long id of the target is not the long id of me then pass tree_Outline
   return the tree_Outline of the tree_Field of me
end tree_Outline
   
setprop tree_Outline [expansionLevel] someOutline
   if the long id of the target is not the long id of me then pass tree_Outline
   set the tree_Outline [expansionLevel] of the tree_Field of me to someOutline
   return the result
end tree_Outline


--> Title
-
/*
These standard title_View scripts are passed down to be handeled by the title_View of the layout.

In order to avoid recursion if the target = the title_View then the call are passed,
however calls to a target within the body view or to this view itself are accepted.
*/

getprop title_Text
   if the long id of the target contains the title_View of me then pass title_Text
   put the title_View of me into titleView
   put the view_Text of titleView into titleText
   return titleText
end title_Text

setprop title_Text titleText
   if the long id of the target contains the title_View of me then pass title_Text
   put the title_View of me into titleView
   set the view_Text of titleView to titleText
end title_Text

getprop title_TextAlign
   put the title_View of me into titleView
   if the long id of the target = titleView then pass title_TextAlign
   get the title_TextAlign of titleView
   return it
end title_TextAlign

setprop title_TextAlign alignHow
   put the title_View of me into titleView
   if the long id of the target = titleView then pass title_TextAlign
   set the title_TextAlign of titleView to alignHow
end title_TextAlign

getprop icon_IsVisible
   put the title_View of me into titleView
   put the icon_Button of titleView into iconButton
   put the visible of iconButton into someBoolean
   return someBoolean
end icon_IsVisible

setprop icon_IsVisible someBoolean
   put the title_View of me into titleView
   lock screen
   set the visible of the icon_Button of titleView to someBoolean
   if someBoolean is true then
      set the title_TextAlign of titleView to "left"
   else
      set the title_TextAlign of titleView to "centre"
   end if
   unlock screen
end icon_IsVisible


--> Title | Colours
-
getprop colour_Palette
   put the title_View of me into titleView
   if the long id of the target = titleView then pass colour_Palette
   get the colour_Palette of titleView
   return it
end colour_Palette

setprop colour_Palette colourPaletteArray
   put the title_View of me into titleView
   if the long id of the target = titleView then pass colour_Palette
   set the colour_Palette of titleView to colourPaletteArray
end colour_Palette

getprop title_TextColour
   put the title_View of me into titleView
   if the long id of the target = titleView then pass title_TextColour
   get the title_TextColour of titleView
   return it
end title_TextColour

setprop title_TextColour someColour
   put the title_View of me into titleView
   if the long id of the target = titleView then pass title_TextColour
   set the title_TextColour of titleView to someColour
end title_TextColour

getprop title_Colour
   put the title_View of me into titleView
   if the long id of the target = titleView then pass title_Colour
   get the title_Colour of titleView
   return it
end title_Colour

setprop title_Colour someColour
   put the title_View of me into titleView
   if the long id of the target = titleView then pass title_Colour
   set the title_Colour of titleView to someColour
end title_Colour


--> Geometry
-
on LayoutControl pRect
   if the long id of the target is not the long id of me then return empty -- this is important for nested datagrids at the moment.
   if pRect is empty then put the rect of me into pRect
   
   if pRect is empty then put the rect of me into pRect
   put the title_View of me into titleView
   put the body_View of me into bodyView
   
   put the inner_Rect [pRect] of me into innerRect
   put the view_Spacing of me into viewSpacing
   put the body_Indent of me into bodyIndent
   
   put the title_Height of titleView into titleHeight
   if titleHeight is empty then
      put 36 into titleHeight
      -- put the formatted_Height of titleView into titleHeight
      -- if titleHeight is empty then put the height of titleView into titleHeight
   end if
   
   put innerRect into titleRect
   put item 2 of innerRect + titleHeight into headerBottom
   put headerBottom into item 4 of titleRect
   
   put innerRect into bodyRect
   put headerBottom + viewSpacing into item 2 of bodyRect
   add bodyIndent to item 1 of bodyRect
   
   lock screen
   set the rect of titleView to titleRect
   set the rect of bodyView to bodyRect
   -- set the rect_Mask [bodyRect] of bodyView to "red"
   -- set the rect of bodyView to bodyRect
   -- beep
   unlock screen
end LayoutControl

getprop view_Spacing
   put the customproperties of me into propArray
   put propArray ["view_Spacing"] into viewSpacing
   
   if viewSpacing is empty then pass view_Spacing
   if viewSpacing is empty then return 4
   return viewSpacing
end view_Spacing

setprop view_Spacing viewSpacing
   set the view_DisplayProperty ["view_Spacing"] of me to viewSpacing
   dispatch "LayoutControl" to me -- changes the target
   return the result
end view_Spacing

getprop body_Indent
   put the customproperties of me into propArray
   put propArray ["body_Indent"] into bodyIndent
   if bodyIndent is empty then pass body_Indent
   return bodyIndent
end body_Indent

setprop body_Indent bodyIndent
   set the view_DisplayProperty ["body_Indent"] of me to bodyIndent
   dispatch "LayoutControl" to me -- changes the target
   return the result
end body_Indent

getprop title_Height
   put the customproperties of me into propArray
   put propArray ["title_Height"] into titleHeight
   
   if titleHeight is empty then pass title_Height
   return titleHeight
end title_Height

setprop title_Height titleHeight 
   set the view_DisplayProperty ["title_Height"] of me to titleHeight
   dispatch "LayoutControl" to me -- changes the target
   return the result
end title_Height

getprop title_DefaultHeight
   return the height of the title_View of me
end title_DefaultHeight

getprop title_ViewName
   put the title_View of me into titleView
   put the view_Name of titleView into vName
   return vName
end title_ViewName
 
setprop title_ViewName vName
   put the title_View of me into titleView
   set the view_Swap of titleView to vName
   return the result
end title_ViewName

getprop body_ViewName
   put the body_View of me into bodyView
   put the view_Name of bodyView into vName
   return vName
end body_ViewName
 
setprop body_ViewName vName
   put the body_View of me into bodyView
   set the view_Swap of bodyView to vName
   return the result
end body_ViewName

getprop body_ViewType
   put the body_View of me into bodyView
   put the view_Name of bodyView into vName
   switch vName
      case "View|Tree|Field"
         return "tree"
      case  "View|Rev|Datagrid"
         return "datagrid"
      case "View|Rev|Datagrid|Form"
         return "datagrid form"
   end switch
end body_ViewType
 
setprop body_ViewType bodyViewType
   put the body_View of me into bodyView
   switch bodyViewType
      case "tree"
         put "View|Tree|Field" into vName
         break
      case "datagrid"
         put "View|Rev|Datagrid" into vName
         break
      case "datagrid form"
         put "View|Rev|Datagrid|Form" into vName
         break
   end switch
   set the view_Swap of bodyView to vName
end body_ViewType

getprop body_ViewTypes
   return "tree,-,datagrid,datagrid form"
end body_ViewTypes


--> Objects
-
getprop tree_View
    return the long id of me
end tree_View

getprop view_Object
    return the long id of me
end view_Object

getprop menu_Button
   if the long id of me is not the long id of the target then pass menu_Button
   put the title_View of me into titleView
   put the menu_Button of titleView into mButton
   return mButton
end menu_Button

getprop header_View
   return the title_View of me
end header_View

getprop body_View
   put the tree_Field of me into someView
   return someView
end body_View

getprop title_View
   put the long id of control "Tree Title" of me into someView
   return someView
end title_View

getprop tree_Field
   put the long id of control "Tree Field" of me into someView
   return someView
end tree_Field
