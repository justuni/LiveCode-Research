script "behavior_LayoutMobileOrientation"
--> MetaData
-
license: GPLv3
name: behavior_LayoutMobileOrientation
type: behavior
version: 0.1


--> Variables
-
local LocalArray


--> Events
-
on preOpenStack
   if the environment = "mobile" then
      -- set the fullscreenmode of this stack to "showAll"
      set the mobile_AllowedOrientation of me to "all"
      
      -- assumes we start with "portrait" as default in standalone settings
      get the effective working screenrect
      put item 2 of it into statusBarHeight
      put item 3 of it into portraitRight
      put item 4 of it into portraitBottom
      orientation_SetScreenRect portraitRight, portraitBottom, statusBarHeight
      
      -- set up initial geometry
      orientation_SetRects "portrait"
      
      -- set the url of widget "browser" to "http://dev.himalayanacademy.com/monastery/meet-the-monks"
   end if
   pass preOpenStack
end preOpenStack

setprop mobile_AllowedOrientation orientationType
   -- orientationType is a convenience short cut for sets of orientations
   switch orientationType
      case "portrait"
         put "portrait,portrait upside down" into allowedOrientations
         break
      case "landscape"
         put "landscape left,landscape right" into allowedOrientations
         break
      default -- allow all, ignoring face up/down
         put "portrait,portrait upside down,landscape left,landscape right" into allowedOrientations
   end switch
   
   mobileSetAllowedOrientations allowedOrientations
   
   -- store in case needed
   put orientationType into LocalArray ["mobile_AllowedOrientation"]
   put allowedOrientations into LocalArray ["allowedOrientations"]
end mobile_AllowedOrientation

on orientationChanged
   -- screenrect hasn't changed yet
   -- resizeStack is sent when the stack is resized (orientationChanged does not do this for us)
   
   put mobileDeviceOrientation() into tOrientation
   orientation_SetRects tOrientation
   return tOrientation
end orientationChanged


--> Geometry
-
command orientation_SetRects tOrientation
   if tOrientation is among the items of "face up" then
      return "face up"
   end if
   
   put orientation_GetScreenRect (tOrientation) into sRect
   set the rect of this stack to sRect
   
   -- can't use "the cardRect" as we are still on the pre-rotated card (so calculate from orientation)
   put screen_GetCardRect (sRect) into cRect
   view_SetGeometry cRect
   
   return cRect & CR & sRect
end orientation_SetRects

function orientation_GetScreenRect tOrientation
   switch
      case tOrientation contains "portrait"
         return LocalArray ["portrait rect"]
         return someRect
      case tOrientation contains "landscape"
         return LocalArray ["landscape rect"]
         return someRect
   end switch
end orientation_GetScreenRect

command orientation_SetScreenRect portraitRight, portraitBottom, statusBarHeight
   -- let's calculate and store the landscape and protrait rects
   -- use in a startup handler where we know the hard wired initial orientation
   
   put 0,statusBarHeight,portraitRight,portraitBottom into portraitRect
   put portraitRect into LocalArray ["portrait rect"]
   
   put 0,statusBarHeight,portraitBottom,portraitRight into landscapeRect
   put landscapeRect into LocalArray ["landscape rect"]
end orientation_SetScreenRect


--> Custom
-
private command view_SetGeometry cRect
   rect_Subtract cRect, 30
   set the rect of control 1 of me to cRect
end view_SetGeometry


--> Custom | Deps
-
function screen_GetCardRect sRect 
   -- here we calculate what the card rect is from a global screen rect
   -- sometimes it is not possible to use "the rect of this card" as it is not available yet
   -- status bar moves down the stack, so card rect differs from screen rect
   -- so we calculate screen rect from orientation    
   -- this also moves the stack below the status bar
   
   put 0,0 into cRect
   put item 3 of sRect - item 1 of sRect into cWidth
   put cWidth into item 3 of cRect
   put item 4 of sRect - item 2 of sRect into cHeight
   put cHeight into item 4 of cRect
   return cRect
end screen_GetCardRect

command rect_Subtract @someRect, someNum
   add someNum to item 1 of someRect
   add someNum to item 2 of someRect
   subtract someNum from item 3 of someRect
   subtract someNum from item 4 of someRect
end rect_Subtract
