script "Global_Movie_Window_Menu"
--> MetaData
-
license: GPLv3
name: Global_Movie_Window_Menu
type: controller
version: 0.1


--> Global | Movie | Window | Menu
-
on menu_FadeInVideo mTarget
    put the movie_View of mTarget into movieView
    set the stack_Faded of movieView to false
    focus on the movie_Player of movieView
end menu_FadeInVideo

on menu_FadeOutVideo mTarget
    put the movie_View of mTarget into movieView
    set the stack_Faded of movieView to true
    focus on the movie_Player of movieView
end menu_FadeOutVideo

on menu_ShowVideo mTarget, someBoolean
    put the stack_Object of mTarget into movieStack
    set the visible of movieStack to someBoolean
end menu_ShowVideo

on _
end _
    
on menu_WindowRect mTarget, screenRectChoice
    put the movie_View of mTarget into movieView
    if exists(movieView) is false then return opn_Error [merge("Cannot find movie view of target: '[[mTarget]]'")]
    put the stack_Object of movieView into movieStack
     
    switch screenrectChoice
        case "Centre in screen"
            set the loc of movieStack to the screenloc
            break
         case "Half Original Size"
            put the media_HalfOriginalRect of movieView into localRect
            put the short name of movieStack into stackName
            put rect_GetGlobal(localRect, stackName) into someRect
            set the rect of movieStack to someRect
            break
        case "Original Size"
            put the short name of movieStack into stackName
            put the media_OriginalRect of movieView into localRect
            put rect_GetGlobal(localRect, stackName) into someRect
            set the rect of movieStack to someRect
            break
        case "Double Original Size"
            put the media_DoubleOriginalRect of movieView into localRect
            put the short name of movieStack into stackName
            put rect_GetGlobal(localRect, stackName) into someRect
            set the rect of movieStack to someRect
            break
        default
            menu_SetChoice screenRectChoice, screenNumber, someRect
            replace quote with empty in someRect
            set the rect of movieStack to someRect
    end switch
    
    focus on the movie_Player of movieView
end menu_WindowRect

on movie_SetCardMargin mTarget, borderSize
    put the movie_View of mTarget into movieView
    put the card_Object of mTarget into cardObject
    
    switch borderSize
        case "12"
            break
        case "36"
            break
        case "0"
             break
        case "-"
        case "Ask"
            put the card_Margin of cardObject into cardViewMargin
            if not(cardViewMargin is a number or cardViewMargin is a rect) then put 0 into cardViewMargin
            ask "What margin would you like for the views on this card?" with cardViewMargin
            if the result is "Cancel" then exit to top
            
            put it into borderSize
            break
    end switch
    
    set the card_Margin of cardObject to borderSize
    view_ResizeToCard
end movie_SetCardMargin

on menu_WindowStyle mTarget, bodyStyle
    put the stack_Object of mTarget into stackObject
    switch bodyStyle
        case "normal"
            set the decorations of stackObject to default
            break
        case "no title"
            set the decorations of stackObject to "noShadow"
            break
    end switch
end menu_WindowStyle

on menu_CanResize mTarget, someBoolean
    put the stack_Object of mTarget into stackObject
    set the resizable of stackObject to someBoolean
end menu_CanResize

on menu_ShowController mTarget, someBoolean
    set the movie_ControllerShowing of mTarget to someBoolean
end menu_ShowController

on _
end _
    
on menu_RememberMoviePosition mTarget
    put the movie_View of mTarget into movieView
    if exists(movieView) is false then return opn_Error [merge("Cannot find movie view of target: '[[mTarget]]'")]
    
    ask "Give a name to this layout..."
    put it into layoutName
    if layoutName is empty then exit to top
    
    put the mobile_Name of movieView into movieView
    put the rect of movieView into movieRect
    put movieRect into positionArray [movieView]
    
    layout_SetPositionArray layoutName, positionArray
end menu_RememberMoviePosition

on menu_RestoreMoviePosition mTarget, layoutName
    put the movie_View of mTarget into movieView
    if exists(movieView) is false then return opn_Error [merge("Cannot find movie view of target: '[[mTarget]]'")]
    
    put layout_GetPositionArray(layoutName) into positionArray
    repeat for each key someView in positionArray
        put positionArray [someView] into someRect
        set the view_Rect of someView to someRect
    end repeat
end menu_RestoreMoviePosition

on menu_SetMovieSize mTarget, movieSize
    put the movie_View of mTarget into movieView
    if exists(movieView) is false then return opn_Error [merge("Cannot find movie view of target: '[[mTarget]]'")]
    
    set the movie_Size of movieView to movieSize
end menu_SetMovieSize


--> Global | Movie | Window | Menu | Props
-

--> Global | Movie | Window | Menu | Disabled
-


--> Movie | Window | Props
-
getprop disabled_FadeInVideo [mTarget]
    put the movie_View of mTarget into movieView
    return not the stack_Faded of movieView
end disabled_FadeInVideo

getprop disabled_FadeOutVideo [mTarget]
    put the movie_View of mTarget into movieView
    return the stack_Faded of movieView
end disabled_FadeOutVideo


--> Movie | Window | Props
-
getprop show_Video [mTarget]
   put the stack_Object of mTarget into movieStack
   return the visible of movieStack
end show_Video

getprop layout_Names [mTarget]
   return empty
   put movie_GetDisplayCard() into modelObject
   put model_GetArray("uOPN_ViewPositions", modelObject) into positionArray
   return keys(positionArray)
end layout_Names

function layout_GetPositionArray layoutName
    put movie_GetDisplayCard() into modelObject
    put model_GetValue(layoutName, modelObject, "uOPN_ViewPositions") into positionArray
    split positionArray with CR and tab
    return positionArray
end layout_GetPositionArray

on layout_SetPositionArray layoutName, positionArray
    put movie_GetDisplayCard() into modelObject
    combine positionArray with CR and tab
    model_SetValue layoutName, modelObject, positionArray, "uOPN_ViewPositions"
end layout_SetPositionArray

getprop show_Controller [mTarget]
   return the movie_ControllerShowing of mTarget 
end show_Controller

getprop movie_Sizes
    put "Original size" & CR after subMenu
    put "Double Original size" & CR after subMenu
    put "Full screen" & CR after subMenu
    
    delete last char of subMenu
    return subMenu
end movie_Sizes

getprop border_Size [mTarget]
   if exists(mTarget) then
      put the card_Object of mTarget into cardObject
   else
      put movie_GetDisplayCard() into cardObject
   end if
   put the card_Margin of cardObject into cardMargin
   return cardMargin
end border_Size

getprop body_Style [mTarget]
   if exists(mTarget) then
      put the stack_Object of mTarget into movieDisplayStack
   else
      put movie_GetDisplayCard() into cardObject
      put the stack_Object of cardObject into movieDisplayStack
   end if
   
   if the decorations of movieDisplayStack is "default" then
      return "normal"
   else
      return "no title"
   end if
end body_Style

getprop can_Resize [mTarget]
    if exists(mTarget) then
        put the stack_Object of mTarget into movieDisplayStack
    else
        put movie_GetDisplayCard() into cardObject
        put the stack_Object of cardObject into movieDisplayStack
    end if
    
    put the stack_Object of mTarget into stackObject
    return the resizable of stackObject
end can_Resize

getprop screen_RectChoice [mTarget]
    if exists(mTarget) is false then
        -- should not be posible
        breakpoint
        return empty
    end if
    put the movie_View of mTarget into movieView
    if exists(movieView) is false then return opn_Error [merge("Cannot find movie view of target: '[[mTarget]]'")]
    
    put the stack_Object of movieView into movieStack
    put the short name of movieStack into stackName
     
    put the rect of movieStack into movieRect
    -- put rect_GetCentre(movieRect) into scaleCentre
    put item 1 to 2 of movieRect into scaleCentre
     
    put kwote(movieRect) into rectChoice
    put the media_OriginalRect of movieView into localRect
    put rect_GetGlobal(localRect, stackName) into testRect
    if testRect = movieRect then put CR & "Original Size" after rectChoice
     
    -- put the media_HalfOriginalRect of movieView into localRect
    put rect_ScaleFromCentre(movieRect, 0.5, scaleCentre) into localRect
     
    put rect_GetGlobal(localRect, stackName) into testRect
    if testRect = movieRect then put CR & "Half Original Size" after rectChoice
     
    -- put the media_DoubleOriginalRect of movieView into localRect
    put rect_ScaleFromCentre(movieRect, 2, scaleCentre) into localRect
     
    put rect_GetGlobal(localRect, stackName) into testRect
    if testRect = movieRect then put CR & "Double Original Size" after rectChoice
     
    if the screenloc = the loc of movieStack then put CR & "Centre in screen" after rectChoice
     
    return rectChoice
end screen_RectChoice

getprop screen_RectChoices
    local submenu
    
    put the screenrects into fullScreenRects
    repeat with lineNum = 1 to the number of lines of fullScreenRects
        put line lineNum of fullScreenRects into fullScreenRect
        
        put rect_SubtractMargin(200, fullScreenRect) into innerRect
        replace comma with space in fullScreenRect
        put "Screen" && lineNum & CR & tab & kwote(fullScreenRect) & CR & tab & kwote(innerRect) & CR after submenu
    end repeat
    delete char -1 of submenu
    
    put CR & "-" & CR & "Half Original size" after submenu
    put CR & "Original size" after submenu
    put CR & "Double Original size" after submenu
    put CR & "-" & CR & "Centre in screen" after submenu
    return submenu
end screen_RectChoices
