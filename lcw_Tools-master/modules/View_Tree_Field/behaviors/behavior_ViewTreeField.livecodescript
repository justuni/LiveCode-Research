script "behavior_ViewTreeField"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: behavior_ViewTreeField
type: behavior
version: 0.2


/*
A basic tree field.
*/

local LocalDataArray

getprop view_Object
   return the long id of me
end view_Object

getprop tree_Field
   return the long id of me
end tree_Field

getprop view_Alternatives
   if the long id of the target is not the long id of me then pass view_Alternatives
   
   put view_FilteredPaths("View|Field") & CR after viewNames
   put "-" & CR after viewNames
   put view_FilteredPaths("View|Tree") & CR after viewNames
   delete char -1 of viewNames
   return viewNames
end view_Alternatives


--> Menu | Props
-
/*
These defaults allow you to set and get the menu_Title and even menu_DefaultTitle,
but also generate automatic defaults based on searching for the mTitles in sensible places.

The long and short of it is that you can move default "Tree | Field | Menu" around,
in the script hierarchy and if the menu is there it will be found and the menu_Controller and menu_Title set, else 
it falls back to the global "Global | Tree | Field | Menu".
*/

/*
getprop menu_Title
   put the view_Value ["menu_Title"] of me into mTitle
   -- put the uOPN ["menu_Title"] of me into mTitle
   
   if mTitle is not empty then
      if the menu_ControllerExists [mTitle] of me is true then return mTitle
      set the menu_HierarchyTitle of me to mTitle
      if the result is true then return mTitle
   end if
   put the menu_DefaultTitle of me into mTitle
   return mTitle
end menu_Title

setprop menu_Title mTitle
   set the view_Value ["menu_Title"] of me to mTitle
   -- set the uOPN ["menu_Title"] of me to mTitle
end menu_Title

getprop menu_ToolTitle
   put the view_Value ["menu_ToolTitle"] of the target into mTitle
   if mTitle is not empty then return mTitle
   
   put the menu_DefaultToolTitle of me into globalMenuTitle
   -- menu_SearchGlobalObjectHierarchy globalMenuTitle, testController
   return globalMenuTitle
end menu_ToolTitle

setprop menu_ToolTitle mTitle
   set the view_Value ["menu_ToolTitle"] of me to mTitle
   -- set the uOPN ["menu_ToolTitle"] of me to mTitle
end menu_ToolTitle

getprop menu_DefaultToolTitle
   return "Global | Tree | Field | Menu"
end menu_DefaultToolTitle
*/

--> Menu | Props
-
/*
Can override the tree menuTitle by placing a menu_Title handler in the hierarchy.
*/

getprop menu_DefaultTitle
   put "Tree | Field | Menu" into mTitle
   return mTitle
end menu_DefaultTitle


--> Events
-
on tree_MouseDoubleUp treeView
   -- this is the default behavior
   -- which can be overridden by placing a handler on the cards script
   -- or setting and event_Trigger
   tree_Expand
end tree_MouseDoubleUp

on mouseDown pMouseBtnNum
   if the tree_Dragon of me is true then
      put the tree_SelectedPath of me into someThingToSend
      set the tree_DragData of me to someThingToSend
      return "drag"
   else if the controlKey is "Down" then -- if pMouseBtnNum = 3 then
      -- check the custom menu_Title handler here
      local mTable
      put the menu_Title of me into mTitle
      put the menu_ToolTitle of me into mToolTitle
      if the menu_ControllerExists [mTitle] of me then
         put mTitle into mTable
      else if the menu_ControllerExists [mToolTitle] of me then
         put mToolTitle into mTable
      end if
      
      menu_PopUp mTable
      return "menu"
   else
      trigger_Event the params
      if the result is true then pass mouseDown
   end if
end mouseDown

on mouseUp
    put the the long id of the target into treeField
    put the params into eventParams
    
    if the menu_Down of treeField is not true then
        set the menu_Down of treeField to false
        if the tree_Value ["DoubleClickOnly"] of treeField is true then
            send "trigger_Event eventParams" to treeField in 20 ticks  -- must be a better way
        else
            trigger_Event eventParams
        end if
    else
        set the menu_Down of treeField to false
    end if
    pass mouseUp
end mouseUp

on mouseDoubleUp mouseBtnNum
    trigger_Event the params
    pass mouseDoubleUp
end mouseDoubleUp

on mouseRelease
    trigger_Event the params
    pass mouseRelease
end mouseRelease

on tabKey
    trigger_Event the params
end tabKey

on enterInField
    trigger_Event the params
    pass enterInField
end enterInField

on returnInField
    trigger_Event the params
    if the result is false then
        pass returnInField
    end if
end returnInField

on deleteKey 
   trigger_Event "backspaceKey"
   pass deleteKey
end deleteKey

on backspaceKey
    trigger_Event the params
    pass backspaceKey
end backspaceKey


--> Events | Drag
-
on dragEnter
   trigger_Event the params
   pass dragEnter
end dragEnter

on dragMove
   -- sent before dragEnter?
   trigger_Event the params
   pass dragMove
end dragMove

on dragDrop
   trigger_Event the params
   pass dragDrop
end dragDrop

on dragEnd -- remove data being dragged
   trigger_Event the params
   pass dragEnd
end dragEnd

on dragLeave
    -- sent before dragEnter?
    trigger_Event the params
    pass dragLeave
end dragLeave


--> Tree | Events
-
getprop menu_Down
   return LocalDataArray ["menu_Down"]
end menu_Down

setprop menu_Down someBoolean
   put someBoolean into LocalDataArray ["menu_Down"]
end menu_Down


--> Tree | Props | Data
-
setprop tree_Display [displayInfo] someOutline
   put item 1 of displayInfo into treeTitle
   put item 2 of displayInfo into expansionLevel
   
   lock screen
   if treeTitle is not empty then set the title_Text of me to treeTitle
   set the tree_Outline [expansionLevel] of me to someOutline
   unlock screen
   return true
end tree_Display

getprop tree_Array
   lock messages
   put the displayed_Array of me into someArray
   unlock messages
   if someArray is an array then return someArray
   
   put the tree_TabbedText of me into tabbedText
   put outline_ToArray (tabbedText) into treeArray
   return treeArray
end tree_Array

setprop tree_Array [pLevel] someArray
   -- this now draws a sorted array (slower)
   lock screen
   put array_ToOutline (someArray, true) into someOutline
   set the tree_Outline [pLevel] of me to someOutline
   unlock screen
   
   lock messages
   set the displayed_Array of me to someArray
   unlock messages
   return someOutline
end tree_Array

getprop tree_Outline
   put the tree_Value ["TreeOutline"] of me into someOutline
   return someOutline
end tree_Outline

setprop tree_Outline [expansionLevel] someOutline
    put long id of me into treeField
    tree_PrepareHtmlText someOutline
     
    lock screen
    if expansionLevel is empty then put the tree_DefaultExpansion of treeField into expansionLevel
    tree_DrawFromOutline someOutline, treeField, empty, expansionLevel
    set the view_Rect of treeField to the rect of treeField -- add scrollbar if needed (could be speed up)
    unlock screen
end tree_Outline

getprop tree_Html
   return the htmltext of me
end tree_Html

setprop tree_Html [treeTitle] someHtml
   put the view_DataArray of me into treeArray
   
   lock screen
   set the htmltext of me to someHtml
   Title
   unlock screen
   
   tree_PrepareHtmlText someHtml   
   tree_ReConstuctArrayFromOutline someHtml, treeArray
   set the view_DataArray of me to treeArray
end tree_Html

getprop tree_TabbedText
    put the tree_Value ["TreeOutline"] of me into someOutline
    return html_StripAllTags (someOutline)
end tree_TabbedText

setprop tree_TabbedText [expansionLevel] tabbedText
   set the tree_Outline [expansionLevel] of me to tabbedText
   return the result
end tree_TabbedText


--> Tree | Selected
-
/*
Wrappers to create more elegant syntax.
*/

getprop selected_TabLevel
   return the tree_SelectedDepth of me
end selected_TabLevel

getprop selected_Text
   -- same as selected_Index
   return the tree_SelectedIndex of me
end selected_Text

setprop selected_Text someIndex
   -- same as selected_Index
   set the tree_SelectedIndex of me to someIndex
end selected_Text

getprop selected_Index
    return the tree_SelectedIndex of me
end selected_Index

setprop selected_Index someIndex
    set the tree_SelectedIndex of me to someIndex
end selected_Index
    
getprop selected_Parent [vLineNum]
   put the selected_Path [vLineNum] of me into somePath
   set the itemdelimiter to the tree_Delimiter of me
   put item -2 of  somePath into someItem
   return someItem
end selected_Parent

getprop selected_Path [vLineNum]
   put the long id of me into treeField
   if vLineNum is empty then put the hilitedlines of treeField into vLineNum
   
   put the tree_Delimiter of treeField into pathDelim
   put tree_GetPath (vLineNum, treeField, pathDelim) into treePath
   return treePath
end selected_Path

setprop selected_Path somePath
   put the long id of me into treeField
   put the tree_Delimiter of treeField into pathDelim
   
   tree_SetChosenPath somePath, treeField, pathDelim
   return the result
end selected_Path

getprop top_ParentLine
   put the tree_Delimiter of me into treeDelim
   set the itemdelimiter to treeDelim
   put item 1 of the selected_Path of me into topParentLine
   return topParentLine
end top_ParentLine

getprop top_Array [vLineNum]
   if vLineNum is empty then  put the top_VNum of me into vLineNum
   put the selected_ArrayValue [vLineNum] of me into topArray 
   return topArray
end top_Array

getprop top_CNum
   put the top_ParentLine of me into somePath
   put the view_DataArray of me into treeArray
   return tree_CatLineNumFromOutlineArray (somePath, treeArray)
end top_CNum

getprop top_VNum
   put the top_CNum of me into cNum
   put the view_DataArray of me into treeArray   
   put treeArray ["VisibleCat"] into visCat
   put tree_CatToVLineNum (cNum, visCat) into vNum
   return vNum
end top_VNum

function tree_TranslateCatLineNum cNum, treeField
    put the view_DataArray of treeField into treeArray   
    put treeArray ["VisibleCat"] into visCat
    put tree_CatTovLineNum (cNum, visCat) into vNum
    return vNum
end tree_TranslateCatLineNum

getprop selected_Array [vLineNum]
   put the tree_Array of me into treeArray
   put the selected_ArrayKey [vLineNum] of me into arrayKey -- not dependent on treeDelim
   -- put item 2 of the extents of arrayKey into lastKeyNum
   -- delete variable arrayKey [lastKeyNum]
   put the selected_Index of me into selectedIndex
   put treeArray [arrayKey] into selectedArray [selectedIndex]
   return selectedArray
end selected_Array

getprop selected_ArrayValue [vLineNum]
   put the tree_Array of me into treeArray
   put the selected_ArrayKey [vLineNum] of me into arrayKey -- not dependent on treeDelim
   return treeArray [arrayKey]
end selected_ArrayValue

getprop selected_ArrayKey [vLineNum]
   if vLineNum is not a number then put the hilitedline of me into vLineNum
   put the view_DataArray of me into treeArray   
   put treeArray_GetPathKey (vLineNum, treeArray) into arrayKey
   return arrayKey
end selected_ArrayKey


--> Tree | Links
-
getprop tree_SelectedLink [vLineNum]
   put the long id of me into treeField
   tree_SetVisibleLineNum vLineNum, treeField
   
   -- put field_GetLinkText (vLineNum, treeField) into someLink
   put the short ID of me into fieldID
   put the linkText of word 1 to -1 of line vLineNum of field ID fieldID into someLink -- can't use object reference "treeField" or "me"
   replace "&quot;" with quote in someLink
   
   return someLink
end tree_SelectedLink

setprop tree_SelectedLink [vLineNum] someLink
   put the long id of me into treeField
   tree_SetVisibleLineNum vLineNum, treeField
   
   put the view_DataArray of treeField into treeModelArray
   put treeModelArray ["TreeOutline"] into someOutline
   put treeModelArray ["TreeText"] into treeText
   
   put the tree_CatLineNum [vLineNum] of treeField into cLineNum
   put line cLineNum of treeField into someText
   put html_ConstructNameLink (someText, someLink) into word 1 to -1 of line cLineNum of someOutline
   
   tree_DrawFromOutline someOutline, treeField
   return the result
end tree_SelectedLink

getprop tree_Links
   put the tree_LinkArray of me into linkArray
   return keys(linkArray)
   
   -- another version
   put the long id of me into treeField
   put the tree_Outline of treeField into someOutline
   return html_ExtractLinks (someOutline)
end tree_Links

getprop tree_CatLineLink [cLineNum]
   put the long id of me into treeField
   if cLineNum is empty then put the tree_CatLineNum of treeField into cLineNum
   
   put the tree_Outline of treeField into treeOutline
   put word 1 to -1 of line cLineNum of treeOutline into someLine
   html_DeconstructNameLink someLine, someText, someLink
   replace "'" with quote in someLink
   return someLink
end tree_CatLineLink

getprop tree_LinkArray
   put the tree_Outline of me into treeOutline
   local linkArray
   repeat with lineNum = 1 to the number of lines of treeOutline
      put line lineNum of treeOutline into someLine
      html_DeconstructNameLink someLine, someText, someLink
      put lineNum into linkArray [someLink]
   end repeat
   return linkArray
end tree_LinkArray


--> Tree | Props
-
getprop tree_SelectedDepth [vLineNum]
   if vLineNum is empty then put the tree_VisLineNum of me into vLineNum
   put the view_DataArray of me into treeArray   
   put treeArray ["VisibleCat"] into visCat
   put line vLineNum of visCat into vCatLine
   return item 2 of vCatLine
end tree_SelectedDepth

getprop tree_Delimiter
   put the tree_Value ["Delimiter"] of me into someDelim
   if someDelim is empty then
      put tab into someDelim -- could use a tab?
      -- put "/" into someDelim -- could use a tab?
   end if
   return someDelim
end tree_Delimiter

setprop tree_Delimiter someDelim
   set the tree_Value ["Delimiter"] of me to someDelim
end tree_Delimiter

getprop tree_SelectedIndex
   put the field_SelectedIndex of me into someLines
   replace tab with empty in someLines
   return someLines
end tree_SelectedIndex

setprop tree_SelectedIndex someIndex
   set the field_SelectedIndex of me to someIndex
end tree_SelectedIndex


--> Tree | Props | Toggle
-
getprop tree_IsIndex
    return the multiplelines of me is true and the noncontiguoushilites of me is true
end tree_IsIndex

setprop tree_IsIndex someBoolean
    set the multiplelines of me to someBoolean
    set the noncontiguoushilites of me to someBoolean
end tree_IsIndex

getprop tree_HasArrows    
   put the tree_Style of me into treeStyle
   return treeStyle contains "arrows"
end tree_HasArrows

setprop tree_HasArrows boolean
   put the long id of me into treeField
   
   put the tree_ExpandedColour of treeField into expandedColour
   put the tree_CollapsedColour of treeField into collapsedColour
   
   if boolean is true then
      put html_RightArrowChar() into minusSymbol
      put html_DownArrowChar() into plusSymbol
      put html_TabChar() into equalsSymbol
      tree_SetSymbols treeField, plusSymbol, minusSymbol, equalsSymbol
   else
      tree_SetSymbols treeField, empty, empty, empty
   end if
   
   put the tree_Style of treeField into treeStyles
   if boolean is true then
      line_Add "arrows", treeStyles
   else
      line_Delete "arrows", treeStyles
   end if
   set the uOPN ["DisplayStyle"] of treeField to treeStyles
   
   return the tree_Refresh of me
end tree_HasArrows

getprop tree_Dragon
   put the model_Value ["tree_Dragon"] of me is true into someBoolean
   return someBoolean
end tree_Dragon

setprop tree_Dragon someBoolean
   set the model_Value ["tree_Dragon"] of me to someBoolean
end tree_Dragon

getprop tree_IsPlusMinusZero
   put the tree_Style of me into treeStyles
   return "PlusMinusZero" is among the lines of treeStyles
end tree_IsPlusMinusZero

setprop tree_IsPlusMinusZero boolean
   put the tree_ExpandedColour of me into expandedColour
   put the tree_CollapsedColour of me into collapsedColour
   put "PlusMinusZero" into someStyle
   put the tree_Style of me into treeStyles
   
   set the wholematches to true
   put lineoffset (someStyle, treeStyles) into lineNum
   put the view_DataArray of me into treeArray
   
   return the tree_Refresh of the target
end tree_IsPlusMinusZero

getprop tree_Refresh
   put the long id of me into treeField
   
   if litLines is empty then put the hilitedlines of treeField into litLines
   lock screen
   tree_DrawField treeField
   tree_ReStyle treeField
   unlock screen
end tree_Refresh 

getprop tree_IsLeaf [cLineNum]
   put the tree_NumberOfChildren [cLineNum] of me into childNum
   if childNum > 0 then
      return false
   else
      return true
   end if
end tree_IsLeaf

getprop tree_Locked
   return the locktext of me
end tree_Locked
    
setprop tree_Locked someBoolean
   put the long id of me into treeField
   
   lock screen
   if someBoolean is true then
      put the text of treeField into displayedOutline
      set the tree_Outline of treeField to displayedOutline
      -- tree_InitialiseFromTabbed displayedOutline, treeField
   else
      put the tree_Outline of treeField into tabbedText
      set the text of treeField to tabbedText
   end if
   
   set the traversalon of treeField to (not someBoolean)
   set the listbehavior of treeField to someBoolean
   set the locktext of treeField to someBoolean
   unlock screen
end tree_Locked


--> Tree | LineNum| Visible
-
getprop tree_VisLineNum
   return the hilitedline of me
end tree_VisLineNum

setprop tree_VisLineNum [expandOnly] vLineNum
   put the long id of me into treeField
   
   tree_SetVisibleLineNum vLineNum, treeField
   
   put tree_TranslateVLineNum (vLineNum, treeField) into cLineNum
   set the tree_CatLineNum [expandOnly] of treeField to cLineNum
   put the result into didExpand
   
   if vLineNum is 0 then return empty
   -- set the hilitedlines of treeField to empty
   set the hilitedlines of treeField to vLineNum
   return didExpand
end tree_VisLineNum


--> Tree | LineNum| Visible
-
getprop tree_CatLineNum [vLineNum]
   put the long id of me into treeField
   
   tree_SetVisibleLineNum vLineNum, treeField
   put tree_TranslateVLineNum (vLineNum, treeField) into cLineNum
   return cLineNum
end tree_CatLineNum

setprop tree_CatLineNum [expandOnly] cLineNum
   put the long id of me into treeField
   
   put expandOnly is not false into expandOnly
   put tree_SetExpandedVisibleCat (cLineNum, treeField, tVisibleCat, treeArray, expandOnly) into didExpand
   set the view_DataArray of treeField to treeArray
   get the tree_Refresh of treeField
   return didExpand
end tree_CatLineNum


--> Tree | Selected | Array
-
function treeArray_GetPathKey vLineNum, treeArray
   local arrayKey
   
   put treeArray ["VisibleCat"] into visCat
   put treeArray ["TreeCat"] into treeCat
   put treeArray ["TreeText"] into treeText
   
   put line vLineNum of visCat into visCatLine
   put item 1 of visCatLine into cLineNum
   put line cLineNum of treeCat into catLine
   put line (item 1 of catLine) of treeText into selectedPathItem
   
   repeat with itemNum =1 to the number of lines of treeCat -- just for safety
      put item 6 of catLine into cLineNum
      if cLineNum < 1 then exit repeat
      
      put line cLineNum of treeText into pathItem
      put pathItem into reverseArray [itemNum]
      put line cLineNum of treeCat into catLine
   end repeat
   
   put itemNum into maxKeyNum
   put selectedPathItem into arrayKey [maxKeyNum]
   repeat for each key reverseKeyNum in reverseArray
      put maxKeyNum - reverseKeyNum into arrayKeyNum
      put reverseArray [reverseKeyNum] into arrayKey [arrayKeyNum]
   end repeat
   return arrayKey
end treeArray_GetPathKey


--> Tree | Path
-
getprop tree_SelectedPath [vLineNum]
  return the selected_Path [vLineNum] of me
end tree_SelectedPath

setprop tree_SelectedPath somePath
   set the selected_Path [vLineNum] of me to somePath
   return the result
end tree_SelectedPath

getprop tree_Path [cLineNum]
    put the long id of me into treeField
    if cLineNum is empty then put the tree_CatLineNum of treeField into cLineNum
     
    put the view_DataArray of treeField into treeArray   
    put treeArray ["TreeText"] into treeText
    put treeArray ["TreeCat"] into treeCat
    put the tree_Delimiter of treeField into treeDelim
    
    put tree_PathFromCatLineNum (cLineNum, treeCat, treeText, treeDelim) into treePath
    return treePath
end tree_Path

getprop tree_CollapsedColour
   put the tree_Field of the target into treeField
   if exists(treeField) is false then return empty
   return the view_DisplayValue ["collapsedColour"] of the target
end tree_CollapsedColour

getprop tree_ExpandedColour
   put the tree_Field of the target into treeField
   if exists(treeField) is false then return empty
   return the view_DisplayValue ["expandedColour"] of treeField
end tree_ExpandedColour

getprop tree_FormattedWidth
    put the tree_Field of the target into treeField
    put the formattedwidth of treeField into someWidth
    return someWidth
end tree_FormattedWidth

getprop tree_MinimumWidth
    put the uOPN["tree_MinimumWidth"] of the target into minimumTreeWidth
    return minimumTreeWidth
end tree_MinimumWidth

getprop tree_NumberOfChildren [cLineNum]
   put the tree_Field of the target into treeField
   if exists(treeField) is false then return empty
   
   if cLineNum is empty then put the tree_CatLineNum of treeField into cLineNum
   
   put the view_DataArray of treeField into treeArray
   put treeArray ["TreeCat"] into fullCat
   put line cLineNum of fullCat into catLine
   put item 7 to -1 of catLine into childLineList
   return the number of items of childLineList
end tree_NumberOfChildren

getprop tree_Style
   put the tree_Field of the target into treeField
   if exists(treeField) is false then return empty
   return the view_DisplayValue ["TreeStyle"] of treeField
end tree_Style

getprop tree_ViewPropertyList
    -- a default value (could be in script of tree view itself)
    return "title_Text,tree_TitleColour,tree_Dragon"
end tree_ViewPropertyList


--> Tree | Handlers
-
private command tree_PrepareHtmlText @someOutline
    replace "<p>" with empty in someOutline
    replace "</p>" with empty in someOutline
    replace "&#9;" with tab in someOutline
end tree_PrepareHtmlText

command tree_Expand vLineNum
   put the long id of me into treeField
   if vLineNum is empty then put the hilitedline of treeField into vLineNum
   if tree_SetExpandedVisibleCat (vLineNum, treeField, visCat, treeArray) is true then
      lock screen
      put the scroll of treeField into originalScroll
      tree_DrawFromVisCat visCat, treeArray, treeField
      set the hilitedlines of treeField to vLineNum
      set the scroll of treeField to originalScroll
      unlock screen
   end if
end tree_Expand

function tree_SetExpandedVisibleCat vLineNum, treeView, @tVisibleCat, @treeArray, expandOnly, pModelType
   put the view_DataArray of treeView into treeArray   
   tree_ClickAndCollapseArrays vLineNum, tVisibleCat, treeArray, expandOnly
   put the result into isExpanded
   set the view_DataArray [pModelType] of treeView to treeArray
   return isExpanded
end tree_SetExpandedVisibleCat

command tree_ClickAndCollapseArrays vLineNum, @tVisibleCat, @treeArray, expandOnly
    if vLineNum is 0 then  -- special case for initialization
        put treeArray ["TreeTop"] into tVisibleCat
    else
        put treeArray ["VisibleCat"] into tVisibleCat
        put line vLineNum of tVisibleCat into visCatLine
         
        put treeArray ["TreeCat"] into myTreeCat
        put item 1 of visCatLine into cLineNum
        put line cLineNum of myTreeCat into cCatLine
         
        if item 4 of cCatLine is not 1 then
            -- a LEAF
            return false
        else
            if item 3 of visCatLine is 1 then
                -- EXPANDED
                if expandOnly is true then
                    -- already expanded so do nothing
                    return false
                else
                    -- expanded, so contract
                    put 0 into item 3 of line vLineNum of tVisibleCat
                    put item 5 of cCatLine into newNext
                     
                    put treeArray ["TreeMax"] into lastCatLineNum
                    if newNext > lastCatLineNum then
                        put line 1 to vLineNum of tVisibleCat into tVisibleCat
                    else
                        put lineoffset( cr & item 5 of cCatLine, tVisibleCat) into nextLineNum
                        delete line (vLineNum + 1) to nextLineNum of tVisibleCat # uses fullCat
                    end if
                end if
            else
                -- CONTRACTED, MUST EXPAND
                put 1 into item 3 of line vLineNum of tVisibleCat
                put item 7 of cCatLine into catChildren # uses fullCat for children
                 
                repeat for each word W in catChildren
                    put line W of myTreeCat into catLine
                    tree_SetCollapsed catLine
                    put cr & catLine after tExp
                end repeat
                put tExp after line vLineNum of tVisibleCat
            end if
        end if
    end if
    
    put tVisibleCat into treeArray ["VisibleCat"]
    return true
end tree_ClickAndCollapseArrays

on tree_TabKey treeView
    put the tree_Field of treeView into treeField
    if the locktext of treeField is false then
        if the selectedtext of treeField is empty then
            put word 2 of the selectedline of treeField into selectedLineNums
        else
            put the hilitedlines of treeField into selectedLineNums
        end if
        
        put the short id of treeField into viewID
        put the stack_Object of treeField into stackObject
        
        repeat for each item selectedLineNum in selectedLineNums
            if the shiftkey is "Down" then
                put line selectedLineNum of the text of treeField into osTitle
                if text_StringCount(tab, osTitle) > 0 then
                    delete char 1 of line selectedLineNum of fld id viewID of stackObject
                end if
            else
                put tab before char 1 of line selectedLineNum of fld id viewID of stackObject
            end if
        end repeat
        select after last char of line selectedLineNum of fld id viewID of stackObject
    end if
end tree_TabKey

on tree_ReturnInField treeView
    put the tree_Field of treeView into treeField
    if the locktext of treeField is false then
        put word 2 of the selectedline of treeField into lineNum
        put line lineNum of the text of treeField into osTitle
         
        put text_StringCount(tab, osTitle) into indentLevel
        put text_RepeatString(tab, indentLevel) into whiteSpace
        put return & whiteSpace into tabbedLineText
        put the number of chars of tabbedLineText into extraLegnth
        put tabbedLineText into the selectedchunk
         
        -- updateTree lineNum # if it could keep the current state
        put the short id of treeField into treeFieldID
        select after char -1 of line (lineNum + 1) of fld id treeFieldID	# of stackObject
        return true
    else
        return false
    end if
end tree_ReturnInField


--> Tree | Model | Wrappers
-
function tree_ConstructBaseCat someOutline, startCatLineNum, extraDepth
    -- basic CAT stem: 1, cDepth, cIsExpanded
    if startCatLineNum is empty then put 1 into startCatLineNum
    put empty into tCat
    repeat with lineNum = 1 to the number of lines of someOutline
        put line lineNum of someOutline into osTitle
        put outline_TabLevel(osTitle) + 1 into someDepth
        put startCatLineNum + lineNum - 1 into cLineNum
        -- add extraDepth to someDepth
        put cLineNum & "," & someDepth & "," & "0" & "," & cr after tCat
    end repeat
    return tCat
end tree_ConstructBaseCat

command tree_ConstructCatRecursively @tCat, catSectionParent
    -- was "tree_SetCatIndex"
    put 1 into tNextNum
    add 0 to catSectionParent
    put item 1 of line 1 of tCat into firstCatLineNum
    put the number of lines in tCat into tMax
    repeat until tNextNum > tMax
        put tree_RecursiveAddFamily(tNextNum, catSectionParent, tMax, tCat, firstCatLineNum) into tNextNum
    end repeat
end tree_ConstructCatRecursively

command tree_DeconstructDisplayArray treeDisplayArray, @plusSymbol, @minusSymbol, @equalsSymbol
    put treeDisplayArray ["plusSymbol"] into plusSymbol
    put treeDisplayArray ["minusSymbol"] into minusSymbol
    put treeDisplayArray ["equalsSymbol"] into equalsSymbol
end tree_DeconstructDisplayArray

getprop tree_DefaultExpansion
    return the tree_Value ["DefaultExpansion"] of the target
end tree_DefaultExpansion

command tree_DrawFromOutline someOutline, treeView, newVisCat, expansionLevel
   put the tree_Field of treeView into treeField
   if exists(treeField) is false then return empty
   
   put the view_DisplayArray of treeView into treeDisplayArray
   put the view_DataArray of treeView into treeArray
   
   tree_ReConstuctArrayFromOutline someOutline, treeArray
   
   if expansionLevel is not empty then
      tree_SetExpandedArray treeArray, expansionLevel	# sets vCat
      put treeArray ["VisibleCat"] into newVisCat
   else if newVisCat is empty then
      put treeArray ["VisibleCat"] into newVisCat
   else
      put newVisCat into treeArray ["VisibleCat"]
   end if
   
   put tree_RenderHtml(newVisCat, someOutline, treeDisplayArray) into someHTML
   set the htmltext of treeField to someHTML
   get the field_AutoScrollBar of treeField
   
   set the view_DataArray of treeView to treeArray
   return treeArray
end tree_DrawFromOutline

command tree_ReConstuctArrayFromOutline someOutline, @treeArray, startCatLineNum, catSectionParent, baseDepth
    put someOutline into treeArray ["TreeOutline"]
    put tree_ConstructBaseCat(someOutline, startCatLineNum, baseDepth) into fullCat
    tree_ConstructCatRecursively fullCat, catSectionParent
    delete last char of fullCat
    
    put fullCat into treeArray ["TreeCat"]
    put fullCat into treeArray ["VisibleCat"]
    
    put the number of lines in fullCat into treeArray ["TreeMax"]
    tree_SetTop fullCat, treeArray
     
    put outline_StripLeadingSpace(someOutline) into someText
    put text_StripAllTags (someText) into treeText	-- can be customised html links etc
    put treeText into treeArray ["TreeText"]
    return fullCat
end tree_ReConstuctArrayFromOutline

function tree_RecursiveAddFamily pLineNum, pParent, pMax, @tCat, firstCatLineNum
    /*
    a recursive function that, given a line in the catalog,
    returns the line number of next item at the same or lesser depth
    while building the catalog data for that line and the intervening lines
    in the variable tCat
    */
    
    put line pLineNum of tCat into catLine
    put pLineNum + 1 into tNextNum
    put empty into tChildren
     
    put item 2 of catLine into tDepth
     
    repeat until tNextNum > pMax or item 2 of line tNextNum of tCat <= tDepth
        put (tNextNum + firstCatLineNum - 1) & space after tChildren
        put tree_RecursiveAddFamily(tNextNum, pLineNum, pMax, tCat, firstCatLineNum) into tNextNum
    end repeat
    if (tNextNum - pLineNum) > 1 then
        put 1 into hasChildren
    else
        put 0 into hasChildren
    end if
    put item 1 to 2 of line pLineNum of tCat into basicStem
    put hasChildren into item 3 of basicStem
    put hasChildren into item 4 of basicStem
    
    put tNextNum + firstCatLineNum - 1 into nextCatLineNum
    if pLineNum = 1 then
        put pParent into parentCatLineNum
    else
        put pParent + firstCatLineNum - 1 into parentCatLineNum
    end if
    put basicStem & "," & nextCatLineNum & "," & parentCatLineNum & "," & tChildren into line pLineNum of tCat
    return tNextNum
end tree_RecursiveAddFamily

function tree_RenderHtml someCat, someOutline, treeDisplayArray
    tree_DeconstructDisplayArray treeDisplayArray, plusSymbol, minusSymbol, equalsSymbol
    put treeDisplayArray ["collapsedColour"] into collapsedColour
    put treeDisplayArray ["expandedColour"] into expandedColour
     
    if collapsedColour is empty then
        put plusSymbol & "<b>" into plusTagStart
        put "</b>" into plusTagEnd
    else
        put plusSymbol & "<font color=" & kwote(collapsedColour) & "><b>" into plusTagStart
        put "</b></font>" into plusTagEnd
    end if
    
    if expandedColour is empty then
        put minusSymbol & "<b>" into minusTagStart
        put "</b>" into minusTagEnd
    else
        put minusSymbol & "<font color=" & kwote(expandedColour) & "><b>" into minusTagStart
        put "</b></font>" into minusTagEnd
    end if
    
    put 1 into vLineNum
    put empty into outlineHtml
    put 0 into pLevel
    repeat for each line vDataLine in someCat
        if item 3 of vDataLine is 1 then
            put minusTagStart into oStartTag
            put minusTagEnd into oEndTag
        else if item 4 of vDataLine is 0 then
            put equalsSymbol into oStartTag
            put empty into oEndTag
        else
            put plusTagStart into oStartTag
            put plusTagEnd into oEndTag
        end if
         
        put "&#9;" into htmlTab
        put item 1 of vDataLine into cLineNum
        put line cLineNum of someOutline into osLine
        put item 2 of vDataLine into osDepth
        
        put oStartTag before char osDepth of osLine
        put "<p>" & osLine & oEndTag & "</p>" into newOsLineHtml
        
        -- replace tab with htmlTab in newOsLineHtml
        put newOsLineHtml into line vLineNum of outlineHtml
        add 1 to vLineNum
    end repeat
    return outlineHtml
end tree_RenderHtml

command tree_SetCollapsed @catLine
    if item 4 of catLine is 1 then
        put 0 into item 3 of catLine
    end if
end tree_SetCollapsed

command tree_SetExpandedArray @treeArray, expansionLevel
    if expansionLevel is a number then
        if expansionLevel is 1 then
            put treeArray ["TreeTop"] into treeTop
            put treeTop into treeArray ["VisibleCat"]
        else if expansionLevel is 0 then
            put treeArray ["TreeCat"] into treeCat
            repeat for each line catLine in treeCat
                if item 4 of catLine is 1 then
                    put 1 into item 3 of catLine
                else
                    put 0 into item 3 of catLine
                end if
                put catLine & CR after visCat
            end repeat
            put visCat into treeArray ["VisibleCat"]
        else
            put treeArray ["TreeCat"] into treeCat
            repeat for each line catLine in treeCat
                if item 2 of catLine <= expansionLevel then
                    if item 4 of catLine is 1 and item 2 of catLine < expansionLevel then
                        put 1 into item 3 of catLine
                    else
                        put 0 into item 3 of catLine
                    end if
                    put catLine & CR after visCat
                end if
            end repeat
            put visCat into treeArray ["VisibleCat"]
        end if
    end if
end tree_SetExpandedArray

command tree_SetTop tCat, @treeArray
    -- need to fix for new tCat with isExpanded changed
    put empty into tTop
    repeat for each line catLine in tCat
        -- could change to start depth numbering at 0
        if item 2 of catLine is 1 then
            tree_SetCollapsed catLine
            put catLine & cr after tTop
        end if
    end repeat
    put tTop into treeArray ["TreeTop"]
end tree_SetTop


--> Tree | Deps
-
function tree_CatToVlineNum cLineNum, visCat
   repeat with vLineNum = cLineNum down to 1
      put line vLineNum of visCat into visCatLine
      put item 1 of visCatLine into testCatLineNum
      if testCatLineNum = cLineNum then return vLineNum
   end repeat
   return 0
end tree_CatTovLineNum

function tree_ExpandToCatLineNum cLineNum, treeView
    -- older (used by tree_ExpandToTitle, tree_SetChosenPath)
    -- just another way of doing it (can use "tree_SetExpandedVisibleCat")
    put the view_DataArray of treeView into treeArray   
     
    put treeArray ["TreeCat"] into treeCat
    put line cLineNum of treeCat into tFamily
    if tFamily is empty then return 0
    repeat until item 6 of tFamily is 0
        put line (item 6 of line 1 of tFamily) of treeCat & cr before tFamily
    end repeat
     
    put treeArray ["TreeTop"] into newVisCat
    put newVisCat into treeArray ["VisibleCat"]
    repeat with lineNum = 1 to (the number of lines in tFamily) - 1
        put lineoffset(CR & item 1 of line lineNum of tFamily, CR & newVisCat) into pLineNum
        get tree_SetExpandedVisibleCat(pLineNum, treeView, newVisCat, treeArray)
    end repeat
    
    put tree_CatTovLineNum(cLineNum, newVisCat, treeArray) into vLineNum
    return vLineNum
end tree_ExpandToCatLineNum

on tree_SetChosenPath pPath, treeView, pathDelim
   put the tree_Field of treeView into treeField
   
   put the view_DataArray of treeView into treeArray
   tree_SetExpandedArray treeArray, 1
   set the view_DataArray of treeField to treeArray
   
   set the hilitedlines of treeField to empty
   if pPath is empty then exit to top
   
   if pathDelim is empty then
      -- get a default
      put treeArray ["Delimiter"] into pathDelim
      if pathDelim is empty then
         put "|" into pathDelim
      end if
   end if
   set the itemdelimiter to pathDelim
   
   set the wholematches to true
   put 0 into tSkip
   put treeArray ["TreeText"] into plainOutline
   repeat for each item someItem in pPath
      get lineoffset(someItem, plainOutline, tSkip)
      if it is 0 then exit to top -- NOT FOUND
      add it to tSkip
   end repeat
   get tree_ExpandToCatLineNum(tSkip, treeView)
   get the tree_Refresh of treeField
   set the hilitedlines of treeField to it
end tree_SetChosenPath

command tree_DrawField treeView, pTreeArray
    put the tree_Field of treeView into treeField
    
    lock screen
    put the hilitedlines of treeField into hLines
    put the scroll of treeField into originalScroll
     
    if keys(pTreeArray) is empty then put the view_DataArray of treeView into pTreeArray
    put pTreeArray ["VisibleCat"] into visCat
    tree_DrawFromVisCat visCat, pTreeArray, treeView
     
    set the hilitedlines of treeField to hLines
    set the scroll of treeField to originalScroll
    unlock screen
end tree_DrawField

command tree_DrawFromVisCat visCat, treeArray, treeView
   put the tree_Field of treeView into treeField
   
   put treeArray ["TreeOutline"] into someOutline
   put the view_DisplayArray of treeView into treeDisplayArray
   put tree_RenderHtml(visCat, someOutline, treeDisplayArray) into someHTML
   set the htmltext of treeField to someHTML
   get the field_AutoScrollBar of treeField
   
   put visCat into treeArray ["VisibleCat"]
   set the view_DataArray of treeField to treeArray
end tree_DrawFromVisCat

function tree_GetPath litLines, treeField, pathDelim
    put the view_DataArray of treeField into treeArray   
    put treeArray ["VisibleCat"] into visCat
    put treeArray ["TreeCat"] into treeCat
    put treeArray ["TreeText"] into treeText
    if pathDelim is empty then
        -- get a default
        put treeArray ["Delimiter"] into pathDelim
        if pathDelim is empty then put "|" into pathDelim
    end if
     
    put empty into pathIndex
    repeat for each item vLineNum in litLines
        put line vLineNum of visCat into catLine
        put item 1 of catLine into cLineNum
        put tree_PathFromCatLineNum (cLineNum, treeCat, treeText, pathDelim) into somePath
        put somePath & return after pathIndex
    end repeat
    delete last char of pathIndex
    return pathIndex
end tree_GetPath

command tree_MoveModel oldModelObject, newModelRef, treeField
    set the tree_ModelObject of treeField to newModelRef
    put object_ReferenceToControl(newModelRef, treeField) into newModelObject
    model_MoveArray "uOPN_TreeTable", oldModelObject, newModelObject
end tree_MoveModel

function tree_PathFromCatLineNum cLineNum, treeCat, treeText, pathDelim
    if treeText is empty or cLineNum is empty then return empty
    put line cLineNum of treeCat into catLine
    put line (item 1 of catLine) of treeText into tPath
    
    put "Error: in catalogue" into someError
    repeat the number of lines of treeCat
        if item 6 of catLine < 1 then
            put empty into someError
            exit repeat
        end if
        put line (item 6 of catLine) of treeText & pathDelim & tPath into tPath
        put line (item 6 of catLine) of treeCat into catLine
    end repeat
    
    if someError is empty then
        return tPath
    else
        return someError
    end if
end tree_PathFromCatLineNum

command tree_ResizeToFit treeView
    put the tree_Field of treeView into treeField
    put the title_View of treeField into titleView
     
    put the topleft of treeView into startTopLeft
    set the height of treeField to the formattedheight of treeField
    set the width of treeField to the formattedwidth of treeField
    set the top of treeField to the bottom of titleView
    set the topleft of treeView to startTopLeft
end tree_ResizeToFit

command tree_ReStyle treeView
    if treeView is empty then put the tree_Field of the target into treeView
    if exists(treeView) is false then return false
    put the tree_Field of treeView into treeField
    
    lock screen
    put the tree_ViewPropertyList of treeView into viewPropertyList
    put the view_DisplayArray of treeView into treeDisplayArray
    repeat for each item viewProperty in viewPropertyList
        put the viewProperty of treeView into someValue
        -- put treeDisplayArray [viewProperty] into someValue
        set the viewProperty of treeView to someValue
    end repeat
    unlock screen
end tree_ReStyle

command tree_SetVisibleLineNum @vLineNum, treeView
   put the tree_Field of treeView into treeField
   if exists (treeField) is false then return empty
   if vLineNum is not a number then put item 1 of the hilitedlines of treeField into vLineNum
end tree_SetVisibleLineNum

function tree_TranslateVLineNum vLineNum, treeField
    put the view_DataArray of treeField into treeArray   
    put treeArray ["VisibleCat"] into visCat
    put line vLineNum of visCat into visCatLine
    put item 1 of visCatLine into cLineNum
    return cLineNum
end tree_TranslateVLineNum


--> Tree | Model
-
getprop tree_Value [someKey]
   put the view_DataArray of me into dataArray
   return dataArray [someKey]
end tree_Value

setprop tree_Value [someKey] someValue
   put the view_DataArray of me into dataArray
   put someValue into dataArray [someKey]
   set the view_DataArray of me to dataArray
   return the result
end tree_Value


--> View | Array
-
getprop view_Array [pUseCard]
   if pUseCard is not false then return the view_CardArray of the target
   
   put the view_Object of the target into viewObject
   if exists(viewObject) is empty then return empty
   
   lock messages
   put the view_Array of viewObject into viewArray
   unlock messages
   
   return viewArray
end view_Array

setprop view_Array [pUseCard] viewArray
   if pUseCard is not false then
      set the view_CardArray of the target to viewArray
      return the result
   end if
   
   put the view_Object of the target into viewObject
   if exists(viewObject) is empty then return empty
   
   lock messages
   set the view_Array of viewObject to viewArray
   unlock messages
   
   return viewObject
end view_Array

getprop view_ControllerArray [pUseCard]
   -- contains information about the controllers associated with a single view
   put the long id of the target into someView 
   put the view_Array [pUseCard] of someView into viewArray
   return viewArray ["controllers"]
end view_ControllerArray

getprop view_DisplayArray [pUseCard]
   put the long id of the target into someView 
   put the view_Array [pUseCard] of someView into viewArray
   return viewArray ["display"]
end view_DisplayArray


--> View | Array | Data
-
getprop view_DataArray [modelType]
   if modelType is empty then put the model_Type of me into modelType
   switch modelType
      case "global"
         return the view_GlobalDataArray of the target
      case "custom property"    
         put the view_CustomDataArray of the target into viewData
         return viewData
      default -- case "local"
         return LocalDataArray
   end switch
end view_DataArray

setprop view_DataArray [modelType] dataArray
   if modelType is emtpy then put the model_Type of me into modelType
   switch modelType
      case "global"
         set the view_GlobalDataArray of the target  to viewData
         return the result
      case "custom property"
         set the view_CustomDataArray of the target to viewData
         return the result
      default -- case "local"
         put dataArray into LocalDataArray
   end switch
end view_DataArray


--> View | Array | ???
getprop view_CardArray [pShortName]
   -- stores the info with the card (so replacing views is OK)
   put the view_Object of the target into viewObject
   if viewObject is empty then return empty
   
   if pShortName is empty then put the short name of viewObject into pShortName
   put the card_Object of the target into cardObject
   put the view_Name of viewObject into vName
   
   put the uOPN_NamedViewArray of cardObject into namedViewArray
   put namedViewArray [vName][pShortName] into viewArray
   return viewArray
end view_CardArray

setprop view_CardArray [pShortName] viewArray
   put the view_Object of the target into viewObject
   if viewObject is empty then return empty
   
   if pShortName is empty then put the short name of viewObject into pShortName
   put the card_Object of the target into cardObject
   put the view_Name of viewObject into vName
   
   put the uOPN_NamedViewArray of cardObject into namedViewArray
   put viewArray into namedViewArray [vName][pShortName]
   set the uOPN_NamedViewArray of cardObject to namedViewArray
   return namedViewArray
end view_CardArray


getprop tree_ModelObject
    put the tree_Field of the target into treeView
    if exists(treeView) then
        put the model_Object ["uOPN_TreeTable"] of treeView into treeModelObject
        return treeModelObject
    else
        return empty	#  not a tree view !
    end if
end tree_ModelObject


--> Tree | Model
-
setprop tree_ModelObject newModelRef
    put the tree_Field of the target into treeView
    if exists(treeView) is false then return empty
    
    put the model_Object ["uOPN_TreeTable"] of treeView into oldModelObject
    set the model_Object ["uOPN_TreeTable"] of treeView to newModelRef
    
    tree_MoveModel oldModelObject, newModelRef, treeView
end tree_ModelObject

getprop tree_ModelReference
    put the tree_Field of the target into treeView
    if exists(treeView) is false then return empty
    return the model_Reference ["uOPN_TreeTable"] of treeView
end tree_ModelReference

command model_MoveArray modelName, oldDataObject, newDataObject, modelType
   custom_CopySet modelName, oldDataObject, newDataObject
   custom_DeleteSet modelName, oldDataObject
end model_MoveArray

getprop model_Name
   put the view_Stem of the target into viewStem
   if viewStem is empty then return "opn_Model" -- was "OPN Model"
   
   put toupper(char 1 of viewStem) into char 1 of viewStem -- can remove to speed up
   put "uOPN_" & viewStem into modelName
   return modelName
end model_Name

getprop model_Object [modelName]
   put the long id of the target into targetObject
   
   /*
   -- skipping this to speed things up (can override this default getprop locally in any case)
   if modelName is empty then
      put "OPN Model" into modelName
      -- put the model_Name of targetObject into modelName
   end if
   put the uOPN [modelName] of targetObject into modelObject
   -- put object_ReferenceToControl(modelObject, targetObject) into modelObject
   
   if exists(modelObject) is truethen return modelObject
   */
   
   -- return a sensible default
   switch word 1 of targetObject
      case "stack"
         return targetObject
      case "group"
         if the backgroundbehavior of targetObject is true then
            return the stack_Object of targetObject
         else
            return the card_Object of targetObject
         end if
      default
         return the card_Object of targetObject
   end switch
end model_Object

setprop model_Object [modelName] modelObject
   put the long id of the target into targetObject
   if modelName is empty then put the model_Name of targetObject into modelName
   
   set the uOPN [modelName] of targetObject to the rugged_ID of modelObject
end model_Object

getprop model_Type
   put the uOPN ["model_Type"] of me into modelType
   if modelType is empty then
      return "local"
   else
      return modelType
   end if
end model_Type

setprop model_Type modelType
   set the uOPN ["model_Type"] of me to modelType
end model_Type

getprop model_Types
   return "global,custom property,-,local"
end model_Types


--> Geometry
-
on resizeControl
   if the commandkey is down then
      tree_ResizeToFit
   else
      set the view_Rect of me to the rect of me
   end if
   pass resizeControl
end resizeControl

setprop view_Rect someRect
   lock screen
   set the rect of me to someRect
   if the formattedheight of me > the height of me then
      set the vscrollbar of me to true
      put the scrollbar_Width of me into sWidth
      if sWidth is not empty then
         set the scrollbarwidth of me to sWidth
      end if
   else
      set the vscrollbar of me to false
   end if
   unlock screen
end view_Rect

getprop formatted_Height
    put the formattedheight of me into fHeight
    put the margins of me into someMargin
    margin_Normalize someMargin, lMargin, tMargin, rMargin, bMargin
    return fHeight + tMargin + bMargin + 0
end formatted_Height

getprop formatted_Width
    put the formattedwidth of me into fWidth
    put the margins of me into someMargin
    margin_Normalize someMargin, lMargin, tMargin, rMargin, bMargin
    return fWidth + lMargin + rMargin + 0
end formatted_Width
      
getprop view_Width
    put the tree_Field of me into treeField
    
    put the tree_MinimumWidth of treeField into minTreeWidth
    put the tree_FormattedWidth of treeField into formattedTreeWidth
    if formattedTreeWidth < minTreeWidth then
        return minTreeWidth
    else
        return formattedTreeWidth
    end if
end view_Width

setprop view_Width someWidth
    put the tree_Field of me into treeField
    
    if someWidth is empty then
        put the tree_FormattedWidth of treeField into someWidth
    end if
    put the rect of treeField into groupRect
    put item 1 of groupRect + someWidth into newRight
    put newRight into item 3 of groupRect
    set the view_Rect of treeField to groupRect
end view_Width


--> Deps
-
getprop field_SelectedIndex
   put the long ID of the target into fieldObject
   if word 1 of fieldObject is not "field" then return empty
   return the selectedText of fieldObject
end field_SelectedIndex

setprop field_SelectedIndex someIndex
   put the long ID of the target into fieldObject
   if word 1 of fieldObject is not "field" then return empty
   
   set the wholeMatches to true
   put the text of fieldObject into fullIndex
   repeat for each line someLine in someIndex
      put lineOffset(someLine, fullIndex) into lineNum
      if lineNum is not 0 then put lineNum & comma after litLines
   end repeat
   delete char -1 of litLines
   set the hilitedlines of fieldObject to litLines
   return litLines
end field_SelectedIndex

function array_ToOutline someArray, pSortKeys
   -- recursive version for nested arrays
   local someOutline
   
   if pSortKeys is empty then
      -- faster
      repeat for each key someKey in someArray
         put someKey & CR after someOutline
         get someArray [someKey]
         if it is an array then get array_ToOutline(it)
         if it is not empty then
            put outline_IncreaseIndent(it, 1) & CR after someOutline
         end if
      end repeat
      delete last char of someOutline
      return someOutline
   else
      put keys(someArray) into someKeys
      if line 1 of someKeys is a number then
         sort numeric someKeys
      else
         sort someKeys
      end if
      repeat for each line someKey in someKeys
         put someKey & CR after someOutline
         get someArray [someKey]
         if it is an array then get array_ToOutline (it, pSortKeys)
         if it is not empty then
            put outline_IncreaseIndent (it) & CR after someOutline
         end if
      end repeat
      delete last char of someOutline
      return someOutline
   end if
end array_ToOutline

getprop card_Object
   put the long id of the target into targetObject
   switch
      case word 1 of targetObject = "card"
         return targetObject
      case word 1 of targetObject is among the items of "stack,background,bkgnd,bg"
         return empty  -- no such thing as a unique card_Object
      default
         put text_TokenOffset ("card", targetObject) into tokenNum
         if tokenNum = 0 then
            breakpoint -- bug with sending and rugged ids of behaviors !!!
            put word 3 of targetObject into someID
            put word 5 to -1 of targetObject into stackObject
            repeat for each line cardID in the cardids of stackObject
               put the long id of card id cardID of stackObject into cardObject
               put the number of controls of cardObject into maxNum
               repeat with cNum = 1 to maxNum
                  put the short id of control cNum of cardObject into cID
                  if cID = someID then return cardObject 
               end repeat
            end repeat
            return empty
         else
            delete token 1 to (tokenNum - 1) of targetObject
            put word 1 to -1 of targetObject into cardObject
            return cardObject
         end if
   end switch
end card_Object

command custom_CopySet setName, fromObject, toObject
    set the custompropertyset of fromObject to setName
    put the customproperties of fromObject into someCustomPropertySet_Array
    set the custompropertyset of fromObject to empty
     
    set the custompropertyset of toObject to setName
    set the customproperties of toObject to someCustomPropertySet_Array
    set the custompropertyset of toObject to empty
end custom_CopySet

command custom_DeleteProperty propName, targetObject, pSetName
   put the custompropertyset of targetObject into oSetName
   set the custompropertyset of targetObject to pSetName
   put the customkeys of targetObject into cKeys
   line_Delete propName, cKeys
   set the customkeys of targetObject to cKeys
   if cKeys is empty then
      custom_DeleteSet pSetName, targetObject
   else
      set the custompropertyset of targetObject to oSetName
   end if
   return cKeys
end custom_DeleteProperty

command custom_DeleteSet setName, someObject
   -- was "array_DeleteStored"
   put the custompropertysets of someObject into setNames
   line_Delete setName, setNames
   set the custompropertysets of someObject to setNames
   return setNames
end custom_DeleteSet

command drag_SetGlobalStatus isTrue
    global OPN
    put isTrue into OPN ["Global_Drag"]
end drag_SetGlobalStatus

getprop event_TriggerArray [eventParams]
   -- wrapper around the view_ControllerArray
   -- the bit that responds to a given event
   if eventParams is empty then put "mouseUp" into eventParams
   put the long id of the target into targetObject
   put word 1 of eventParams into eventName
   put the view_ControllerArray of targetObject into controllerArray
   put controllerArray [eventName] into triggerArray
   return triggerArray
end event_TriggerArray

getprop field_AutoScrollBar
   put the long ID of the target into someField
   if word 1 of someField is not "field" then return "Error: target is not a field"
   
   if the formattedHeight of someField > the height of someField then
      set the vScrollbar of someField to true
      return true
   else
      set the vScrollbar of someField to false
      return false
   end if
end field_AutoScrollBar

command folder_Format @someFolder
   -- should be renamed "folder_Normalize"
   if someFolder is empty then return empty
   repeat while last char of someFolder is "/"
      delete last char of someFolder
   end repeat
   put "/" after someFolder
end folder_Format

function folder_ShortFiles someFolder, pFilter, pShowInvisible
   put the directory into originalDirectory
   set the directory to someFolder
   put the files into shortFiles
   set the directory to originalDirectory
   if pFilter is not empty then filter shortFiles with pFilter
   if pShowInvisible is not true then filter shortFiles without ".*"
   return shortFiles
end folder_ShortFiles

function html_DownArrowChar
    -- only works for Mac I think as requires font "Wingdings 3"
    get "<font face='Wingdings 3'>}&#9;</font>"
    replace "'" with quote in it
    return it
end html_DownArrowChar

function html_RightArrowChar
    -- only works for Mac I think as requires font "Wingdings 3"
    get "<font face='Wingdings 3'>&Auml;&#9;</font>"
    replace "'" with quote in it
    return it
end html_RightArrowChar

function html_StripAllTags taggedText
    --was "stripAllTags", "html_StripTags"
    return text_StripAllTags(taggedText)
end html_StripAllTags

function html_TabChar
    return "&#9;"
end html_TabChar

function kwote someText, pQuoteChar
   if pQuoteChar is empty then put quote into pQuoteChar
   return pQuoteChar & someText & pQuoteChar
end kwote

command line_Add someLines, @someIndex
   repeat for each line someLine in someLines
      if someLine is empty then next repeat
      set the wholematches to true
      put lineoffset(someLine, someIndex) into lineNum
      if lineNum is 0 then
         put the number of lines of someIndex into maxLine
         put maxLine + 1 into lineNum
         put someLine into line lineNum of someIndex
      else
         put lineNum & comma after lineNums
      end if
   end repeat
   delete char -1 of lineNums
   return lineNums
end line_Add

command line_Delete someLines, @fromContainer, partLine, skipLines
    set the wholematches to (partLine is empty)
    repeat with ii = 1 to the number of lines of someLines
        put line ii of someLines into someLine
        get lineoffset(someLine, fromContainer, skipLines)
        if it is not 0 then
            put it + skipLines into lineNum
            delete line lineNum of fromContainer
        end if 
    end repeat
    return the number of lines of someIndex
end line_Delete

command margin_Normalize @someMargin, @leftM, @topM, @rightM, @bottomM
   -- fixed bug in setting bottomM when 4th item is empty
   if the number of items of someMargin < 4 then
      put item 1 of someMargin into defaultMargin
      put defaultMargin into leftM
      
      put item 2 of someMargin into actualMargin
      if actualMargin is empty then
         put leftM into topM
      else
         put actualMargin into topM
      end if
      
      put item 3 of someMargin into actualMargin
      if actualMargin is empty then
         put leftM into rightM
      else
         put actualMargin into rightM
      end if
      
      put item 4 of someMargin into actualMargin
      if actualMargin is empty then
         put topM into bottomM
      else
         put actualMargin into bottomM
      end if
   else
      put item 1 of someMargin into leftM
      put item 2 of someMargin into topM
      put item 3 of someMargin into rightM
      put item 4 of someMargin into bottomM
   end if
   put leftM,topM,rightM,bottomM into someMargin
end margin_Normalize

getprop mobile_Name
    put the long name of the target into mobileObject
    object_SetShortStackName mobileObject, mainStackStart, mainStackEnd
    return mobileObject
end mobile_Name

function object_ExtractStack someObject
   set the wholematches to true
   put word (wordOffset ("stack", someObject)) to -1 of someObject into stackObject
   return stackObject
end object_ExtractStack

function object_IsReference objectReference
    -- are other short hand references?
    if word 1 of objectReference is among the items of "stack,background,group,card,button,field,graphic,player,image,scrollbar,cd,btn,fld,grc,img" then
        return true
    else
        return false
    end if
end object_IsReference

getprop object_Name
   put the long ID of the target into targetObject
   
   put the object_Metadata ["name"] of targetObject into someName
   set the uRIP ["name"] of targetObject to someName	# in case it has not already been set
   return someName
end object_Name

function object_ReferenceToControl objectReference, targetObject
    /*
    Changed to return rugged_IDs
     */
    if exists(targetObject) is false then put the long id of the target into targetObject
     
    switch objectReference
        case empty	# return empty instead?
            return the rugged_ID of targetObject
        case "target"
            return the rugged_ID of targetObject
        case "card"
            return the rugged_ID of the card_Object of targetObject
        case "background"
            return the rugged_ID of targetObject
        case "stack"
            return object_ExtractStack(targetObject)
        default
            if object_IsReference(objectReference) then
                -- a direct reference to a revolution control - ie "btn 4"
                put objectReference into referencedObject
            else
                --assume it is a property reference
                put the objectReference of targetObject into referencedObject	# could use regExp instead
            end if
    end switch
     
    -- some error checking
    if exists(referencedObject) then
        return the rugged_ID of referencedObject
    else
        return empty -- was targetObject
    end if
end object_ReferenceToControl

command object_SetShortStackName @someObject, @mainStackStart, @mainStackEnd
    -- was "set_ShortStackBit"
    object_StackNameOffsets someObject, mainStackStart, mainStackEnd, substackStart, substackEnd
    put char mainStackStart to mainStackEnd of someObject into longStackName
     
    if exists(stack longStackName) is false then
        return empty
    else
        put the short name of stack longStackName into shortStackName
        put char mainStackStart to mainStackEnd of someObject into stackPath
        put shortStackName into char mainStackStart to mainStackEnd of someObject
        return stackPath
    end if
end object_SetShortStackName

command object_StackNameOffsets someObject, @mainStackStart, @mainStackEnd, @substackStart, @substackEnd
    -- now modified to look for substacks
     
    put the number of chars of someObject into lastQuoteCharNum
    put lastQuoteCharNum - 1 into mainStackEnd
    put text_OffsetBefore(quote, someObject, lastQuoteCharNum) + 1 into mainStackStart
    
    put someObject into testSubStack
    delete char (mainStackStart - 7) to -1 of testSubStack
     
    -- put offset(space & "stack" && quote, testSubStack) into substackStart
    put offset("stack" && quote, testSubStack) into substackStart
    -- put wordoffset("stack" && quote, testSubStack) into substackStart
     
    if substackStart = 0 then
        put 0 into substackEnd
        return char (mainStackStart - 7) to -1 of someObject
    else
        put 8 - 1 into tweek
        put substackStart + tweek into tSkip
        put offset(quote, testSubStack, tSkip) into substackEnd
        
        put substackStart + tweek into substackStart
        put substackEnd + tSkip - 1 into substackEnd
        return char (substackStart - 7) to -1 of someObject
    end if
end object_StackNameOffsets

function library_PluginFolder pSubFolder, pDontCreate
   put revEnvironmentUserPluginsPath() & "/" into opnRootFolder
   put opnRootFolder & "opn_Plugins/" into someFolder
   
   if pSubFolder is not empty then
      folder_Format pSubFolder   
      put pSubFolder after someFolder
   end if
   
   if pDontCreate is not true then folder_CreateNested someFolder
   return someFolder
end library_PluginFolder

function library_ViewFolder shortFileBit, pDontCreate
   return library_PluginFolder ("opn_Components/views/", pDontCreate) & shortFileBit
end library_ViewFolder

function outline_DecreaseIndent someOsSection, byIndentLevel
    --was "outline_DecreaseIndent"
    if byIndentLevel = 0 then return someOsSection
    repeat with ii = 1 to the number of lines of someOsSection
        put line ii of someOsSection into osTitle
        repeat byIndentlevel
            if char 1 of osTitle is tab then
                delete char 1 of osTitle
            else
                exit repeat
            end if
        end repeat
        put osTitle into line ii of someOsSection
    end repeat
    return someOsSection
end outline_DecreaseIndent

function outline_IncreaseIndent someOsSection, byIndentLevel, indentString
    if indentString is empty then put tab into indentString
    if byIndentLevel is not a number then put 1 into byIndentLevel
    if byIndentLevel = 0 then return someOsSection
    if byIndentLevel < 0 then return outline_DecreaseIndent(someOsSection, abs(byIndentLevel))
    put text_RepeatString(indentString, byIndentLevel) into indentWhiteSpace
    repeat with ii = 1 to the number of lines of someOsSection
        put indentWhiteSpace before line ii of someOsSection
    end repeat
    return someOsSection
end outline_IncreaseIndent

function outline_StripLeadingSpace someOutline
    -- was "outline_StripLeadingTabs"
    repeat for each line someLine in someOutline
        put word 1 to -1 of someLine & CR after someIndex
    end repeat
    delete char -1 of someIndex
    return someIndex
end outline_StripLeadingSpace

function outline_TabLevel someLine
    -- was "titleToTabLevel"
    put 0 into tabLevel
    repeat
        if char (tabLevel+1) of someLine is tab then
            add 1 to tabLevel
        else
            return tabLevel
        end if
    end repeat
end outline_TabLevel

function outline_ToArray tabbedText
    -- this could be done better with clever use of delimiters
    -- itemdelim = CR and tab or funny char insead of CR
    
    local someArray
    replace (CR & tab) with tab in tabbedText
    set the itemdelimiter to tab
    repeat for each line someLine in tabbedText
        put item 1 of someLine into someKey
        put item 2 to -1 of someLine into someValue
        replace tab with CR in someValue
        put someValue into someArray [someKey]
    end repeat
    return someArray
end outline_ToArray

getprop rugged_ID
   -- could also be called "rugged_Object"
   put the long id of the target into pObject
   put revRuggedId (pObject) into ruggedObject
   return ruggedObject
end rugged_ID

getprop stack_Object
   put the long ID of the target into targetObject
   get object_ExtractStack (targetObject)
   return it
end stack_Object

getprop stack_SubName [subStackStem]
   if subStackStem is empty then put "OPN SubStack" into subStackStem
   put the stack_Object of the target into stackObject
   put the mainstack of stackObject into mainStackName
   put mainStackName & "|" & subStackStem into subStackName
   return subStackName
end stack_SubName

function text_InitialCaps someText
    repeat with wordNum = 1 to the number of words of someText
        put tolower(word wordNum of someText) into someWord
        put toupper(char 1 of someWord ) into char 1 of someWord
        put someWord into word wordNum of someText
    end repeat
    return someText
end text_InitialCaps

function text_OffsetAfter string, someText, startChar
    -- version 9.0
    if startChar < 0 then put 0 into startChar
    delete char 1 to startChar of someText
    get offset(string, someText)
    if it is 0 then return 0
    else return it + startChar
end text_OffsetAfter

function text_OffsetBefore someString, someText, beforeHere
  -- was "offsetBefore"
  if beforeHere is not empty then
    delete char beforeHere to -1 of someText
  end if
  put 1 into offsetNum
  put 0 into lastOffset
  repeat
    get text_OffsetAfter(someString, someText, lastOffset)
    if it is 0 then
      return lastOffset
    else
      put it into lastOffset
      add 1 to offsetNum
    end if
  end repeat
end text_OffsetBefore

function text_RepeatString someString, repeatNum
    -- was "opn_GetRepeatString"
    
    put empty into repeatString
    if repeatNum < 0 then
        answer "Repeating forever! text_RepeatString repeatNum =" && repeatNum
        edit the script of me
        exit to top
    end if
    repeat repeatNum
        put someString after repeatString
    end repeat
    return repeatString
end text_RepeatString

function text_StringCount charOrString, someText
    put 0 into startSearchHere
    put 0 into charCount
    repeat
        put text_OffsetAfter(charOrString, someText, startSearchHere) into startSearchHere
        if startSearchHere is 0 then
            exit repeat
        else
            add 1 to charCount
        end if
    end repeat
    return charCount
end text_StringCount

function text_Strip someContainer, charsToStrip, replaceWith
    repeat for each char someChar in charsToStrip
        replace someChar with replaceWith in someContainer
    end repeat
    return someContainer
end text_Strip

function text_StripAllTags someXml
    put  "(<(.|\n)+?>)" into someReg	# 
    -- put "<[^>]*>" into someReg
    return word 1 to -1 of replacetext(someXml, someReg, empty)
end text_StripAllTags

function text_TokenOffset someString, someContainer
   repeat with tokenNum = 1 to the number of tokens in someContainer
      put token tokenNum of someContainer into someToken
      -- lcw_Notify someToken, true
      if someToken = someString then
         return tokenNum
      end if
   end repeat
   return 0
end text_TokenOffset

command trigger_Event eventParams, pGuessTrigger, pTargetObject, mTarget
   -- lcw_Notify eventParams
   if exists (pTargetObject) is false then put the long id of the target into pTargetObject
   put the event_TriggerArray [eventParams] of pTargetObject into triggerArray
   
   if keys(triggerArray) is empty and pGuessTrigger is not false then
      -- lets guess defaults (based on the view_Name)
      put the view_Message [eventParams] of pTargetObject into pigeon
      put the card_Object of pTargetObject into cardObject
      dispatch pigeon to cardObject with pTargetObject  -- see if there is a card level override
      switch it
         case "unhandled"
            -- lets activate the default behavior in the view script
            dispatch pigeon to pTargetObject with pTargetObject
            break
         case "handled"
            break
         case "passed"
            -- the card level script overrode the behavior, but then passed it
            -- lets activate the default behavior in the view script
            dispatch pigeon to pTargetObject with pTargetObject
            break
      end switch
   else
      -- use the info in the stored array
      repeat for each key controllerObjectOrName in triggerArray
         if exists(controllerObjectOrName) is false then
            -- lets look up a named controller
            
            -- else take the target as a default
            put pTargetObject into controllerObject
         else
            put controllerObjectOrName into controllerObject
         end if
         
         put triggerArray [controllerObjectOrName]["handlerName"] into pigeon
         if pigeon is empty then
            put the view_DefaultMessage [eventParams] of pTargetObject into handlerName
         else
            put word 1 of pigeon into handlerName
         end if
         
         -- put the menu_Target [mTitle] of controllerObject into mTarget
         if exists(mTarget) is false then put pTargetObject into mTarget
         
         dispatch handlerName to controllerObject with mTarget
         switch it
            case "handled"
               break
            case "unhandled"
               if the optionKey is "Down" then
                  view_TriggerDisplayHandler handlerName, controllerObject
               else
                  tree_Expand
               end if
               break
            case "passed"
               tree_Expand
               break
         end switch
      end repeat
   end if
   return controllerTable
end trigger_Event

function view_ConstructHierarchy targetObject
   local groupHierarchy
   repeat
      if word 1 of targetObject is "card" then
         -- background groups can cause infinite loops
         -- so have to stop hierarchy check at the card level
         -- which means this will not work for views etc which are at the card level or above!
         return word 1 to -1 of groupHierarchy
      else
         put the view_Object of targetObject into someView
         if someView is empty then return word 1 to -1 of groupHierarchy
         
         put someView & CR before groupHierarchy
         
         put someView into targetObject
         delete word 1 to 4 of targetObject
         if targetObject is empty then return word 1 to -1 of groupHierarchy
      end if
   end repeat
   return groupHierarchy
end view_ConstructHierarchy

getprop view_DefaultMessage [eventName]
   put word 1 of eventName into eventName
   if eventName is empty then put "mouseUp" into eventName
   put the view_Object of the target into someView
   if someView is empty then return eventName
   
   put the object_Name of someView into viewName
   set the itemdelimiter to "|"
   put item 2 of viewName into messageStem
   put wiki_ConstructID(messageStem) into messageStem
   
   put toUpper(char 1 of eventName) into char 1 of eventName
   put messageStem & "_" & eventName into messageName
   return messageName
end view_DefaultMessage

function view_FileToPath someFile, includeStem
   set the itemdelimiter to "/"
   put last item of someFile into viewPath
   
   replace "_" with "|" in viewPath
   set the itemdelimiter to "."
   if item -1 of viewPath is among the items of "livecode.rev.opml.html" then delete last item of viewPath
   if includeStem is true then view_NormalizeName viewPath
   return viewPath
end view_FileToPath

function view_FilteredPaths vName, pIncludeStem
   view_NormalizeName vName
   put view_PathIndex (pIncludeStem) into viewPathIndex
   if vName is empty then return viewPathIndex
   if pIncludeStem is not true then put replacetext (vName, "View\W*", empty) into vName
   filter viewPathIndex with (vName & "*")
   return viewPathIndex
end view_FilteredPaths

getprop view_Hierarchy
   put the long id of the target into targetObject
   put view_ConstructHierarchy (targetObject) into viewObjects
   return viewObjects
end view_Hierarchy

getprop view_Message [eventParams]
   put the view_Stem of the target into viewStem
   if eventParams is empty then
      put "MouseUp" into eventName
   else
      put word 1 of eventParams into eventName
      put toupper(char 1 of eventName ) into char 1 of eventName
   end if
   put viewStem & "_" & eventName into viewMessage
   return viewMessage
end view_Message

getprop view_Name
   -- a value of the target (property is not inherited by objects below)  
   put the uRIP ["name"] of the target into vName
   if the dgProps ["style"] of the target is among the items of "table,form" then
      -- it is a datagrid
      if vName is empty then
         -- in case it is not named (ie a vanilla Rev control)
         return "View|Rev|Datagrid"
      else
         return vName
      end if
   else if the uRIP ["type"] of the target is not "view" then
      -- it is not only views that have uRip names
      return empty
   else
      return vName
   end if
end view_Name

command view_NormalizeName @viewPath
   if viewPath is empty then return empty
   put word 1 to -1 of viewPath into viewPath
   
   set the itemdelimiter to "|"
   repeat with itemNum = 1 to the number of items of viewPath
      put word 1 to -1 of item itemNum of viewPath into someItem
      put someItem into item itemNum of viewPath
   end repeat
   if item 1 of viewPath is not "View" then put "View|" before viewPath
   return viewPath
end view_NormalizeName

function view_PathIndex includeStem
   put view_ShortFiles() into shortFiles
   
   put empty into viewPaths
   repeat for each line someFile in shortFiles
      put view_FileToPath (someFile, includeStem) into viewPath
      put viewPath & CR after viewPaths
   end repeat
   delete last char of viewPaths
   return viewPaths
end view_PathIndex

function view_ShortFiles
   put library_ViewFolder() into someFolder
   put folder_ShortFiles(someFolder) into shortFiles
   return shortFiles
end view_ShortFiles

getprop view_Value [propName]
   put the view_DataArray of the target into viewDataArray
   return viewDataArray [propName]
end view_Value

function wiki_ConstructID someTitle, wikiType
    switch wikiType
        case "Zwiki"
            put text_Strip(someTitle, "'!#@$%^&*()|+" & quote) into someTitle
            put tolower(someTitle) into someTitle
            put space & tab & crlf into xmlSpace
            put "[" & xmlSpace & "]+" into someSpace
            put replacetext(someTitle, someSpace, "_") into someTitle
            break
        case "Trac"
            if the number of words of someTitle > 1 then
                put text_InitialCaps(someTitle) into someTitle
                put space & tab & crlf into xmlSpace
                put "[" & xmlSpace & "]+" into someSpace
                put replacetext(someTitle, someSpace, "") into someTitle
            end if
             
            put text_Strip(someTitle, "'!#@$%^&*()|+" & quote) into someTitle
            break
        default -- "MediaWiki"
            -- should escape funny chars
            replace space with "_" in  someTitle
            put text_Strip(someTitle, "'!#@$%^&*()|+" & quote) into someTitle
    end switch
    return someTitle
end wiki_ConstructID

getprop view_OrCard
   put the long id of the target into targetObject
   repeat
      switch word 1 of targetObject
         case "card"
            return targetObject
         case "stack"
            return empty
         case empty
            return empty
         default
            if the uRIP ["type"] of targetObject is "view" then return targetObject
            if word 1 of targetObject = "group" and the selectGroupedControls of targetObject then return targetObject 
            
            delete word 1 to 4 of targetObject -- does not work for substacks
      end switch
   end repeat
end view_OrCard

getprop view_Stem
   put the view_Object of the target into someView
   -- put the long id of the target into someView
   if exists(someView) is false then return empty
   
   put the uOPN ["view_Stem"] of someView into viewStem
   if viewStem is not empty then
      return viewStem
   else
      put the uRIP ["name"] of someView into viewName
      put view_StemFromName(viewName) into viewStem 
      set the view_Stem of someView to viewStem
      return viewStem
   end if
end view_Stem

setprop view_Stem viewStem
   put the long id of the target into someView
   set the uOPN ["view_Stem"] of someView to viewStem
end view_Stem

function view_StemFromName viewName
   if viewName is empty then return "event"
   
   set the itemdelimiter to "|"
   put word 1 to -1 of item 2 of viewName into viewStem 
   replace space with empty in viewStem
   put tolower(viewStem) into viewStem
   return viewStem
end view_StemFromName

command view_TriggerDisplayHandler handlerName, controllerObject
   put "on" && handlerName && "targetObject" & CR & "end" && handlerName into someHandler
   beep
   edit the script of controllerObject
   
   -- display_Lines someHandler, "Need to handle this message"
   put someHandler
end view_TriggerDisplayHandler
