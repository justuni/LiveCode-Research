script "behavior_ViewMovie"
--> MetaData
-
license: GPLv3
name: behavior_ViewMovie
type: behavior
version: 0.1


--> MetaData
-
author: David Bovill
copyright: David Bovill
name: View|Movie|Player
type: view behavior

/*
This view displays a video.
*/

local LocalArray

on currentTimeChanged newTime
   put the event_Message [newTime]  of me into messageName
   if messageName is empty then pass currentTimeChanged
   
   set the movie_Paused of me to true
   put messageName
   do messageName
   
   /*
   put the event_Array [newTime] of me into messageArray
   if messageArray is an array then
      set the movie_Paused of me to true
      
      put messageArray ["messageName"] into messageName
      put messageName
      do messageName
   else
      -- put newTime
   end if
   */
end currentTimeChanged

-- command movieConvertTime @movieSeconds
if movieSeconds is a number then return empty
set the itemdelimiter to ":"
if the number of items of movieSeconds is 4 then
   put time_HmsfToSeconds (movieSeconds) into movieSeconds
   return empty
else
   return it
end if
end movieConvertTime

function time_HmsfToSeconds hmsf, pFramesPerSecond
   if pFramesPerSecond is not a number then
      put 25 into pFramesPerSecond
   end if
   
   set the itemdelimiter to ":"
   put item 1 of hmsf into someHours
   put item 2 of hmsf into someMinutes
   put item 3 of hmsf into someSeconds
   put item 4 of hmsf into someFrames
   
   add someHours * 3600 to someSeconds
   add someMinutes * 60 to someSeconds
   add someFrames / pFramesPerSecond to someSeconds
   
   return someSeconds
end time_HmsfToSeconds

function time_SecondsToHMSF someSeconds, someFrames
   put the numberformat into oFormat
   set the numberformat to "##"
   
   put someSeconds div 3600 into someHours 
   put someSeconds mod 3600 into secondsLeft
   
   put secondsLeft div 60 into someMinutes
   put secondsLeft mod 60 into secondsLeft
   
   put trunc(secondsLeft) into someSeconds
   put secondsLeft - someSeconds into someFraction
   
   if someFrames is empty then put round(someFraction * 25) into someFrames
   add 0 to someFrames
   
   get someHours & ":" & someMinutes  & ":" & someSeconds  & ":" & someFrames
   set the numberformat to oFormat
   return it
end time_SecondsToHMSF

getprop event_Array [newTime]
   put LocalArray ["events"] into eventArray
   if newTime is empty then return eventArray
   
   put eArray [newTime] into messageArray
   return messageArray
end event_Array

setprop event_Array [newTime] eventArray
   if newTime is empty then
      put eventArray into LocalArray ["events"]
      return eventArray
   end if
   
   put eventArray into LocalArray ["events"][newTime]
   put LocalArray ["events"] into eventArray
   return eventArray
end event_Array

getprop event_Message [newTime] 
   put LocalArray ["events"][newTime]["messageName"] into messageName
   return messageName
end event_Message

setprop event_Message [newTime] messageName
   if messageName is empty then
      delete variable LocalArray ["events"][newTime]
   else
      put messageName into LocalArray ["events"][newTime]["messageName"]
   end if
   return LocalArray ["events"]
end event_Message
   
   
   
   --> Movie
   -
   getprop movie_ControllerID
   put the movie_Player of the target into moviePlayer
   return the moviecontrollerid of moviePlayer
end movie_ControllerID

getprop movie_File
   put the movie_Player of the target into moviePlayer
   put the filename of moviePlayer into mFile
   return mFile
end movie_File

setprop movie_File someFile
   put the movie_View of the target into movieView
   if exists(movieView) is false then return empty
   
   put the rect of movieView into oRect
   put the movie_Player of movieView into moviePlayer
   
   if there is a folder someFile then
      set the itemdelimiter to "."
      put item -1 of someFile into fileExtension
      if fileExtension is among the items of "eyetv.eyetv/" then
         set the eyetv_Bundle of movieView to someFile
         return the result
      end if
   end if
   
   lock screen
   put the filename of moviePlayer into oldFile
   if oldFile = someFile then
      -- to force movie to reload
      set the filename of moviePlayer to empty
   end if
   set the filename of moviePlayer to someFile
   
   -- movie_ResetInfo movieView
   set the view_Rect of movieView to oRect
   focus on moviePlayer
   unlock screen
end movie_File


--> Movie | Clip | Old
-
getprop movie_Paused
   return the paused of the movie_Player of the target
end movie_Paused

setprop movie_Paused someBoolean
   put the movie_Player of the target into moviePlayer
   set the paused of moviePlayer to someBoolean
   focus on moviePlayer
end movie_Paused

getprop movie_PlayRate
   return the playrate of the movie_Player of the target
end movie_PlayRate

setprop movie_PlayRate someRate
   put the movie_Player of the target into moviePlayer
   set the playrate of moviePlayer to someRate
   focus on moviePlayer
end movie_PlayRate

getprop movie_PlaySelection
   return the playselection of the movie_Player of the target
end movie_PlaySelection

setprop movie_PlaySelection someBoolean
   set the playselection of the movie_Player of the target  to someBoolean
end movie_PlaySelection

getprop movie_ShowSelection
   put the movie_Player of the target into moviePlayer
   if exists(moviePlayer) is false then return empty
   
   put the showselection of moviePlayer into someBoolean
   return someBoolean
end movie_ShowSelection

setprop movie_ShowSelection someBoolean
   put the movie_Player of the target into moviePlayer
   if exists(moviePlayer) is false then return empty
   
   set the showselection of moviePlayer to someBoolean
   return moviePlayer
end movie_ShowSelection

getprop movie_ControllerShowing
   put the movie_View of the target into movieView
   put the movie_Player of movieView into moviePlayer
   put the movie_Controller of movieView into movieController
   
   if exists(movieController) then
      return the visible of movieController
   else
      return the showcontroller of moviePlayer
   end if
end movie_ControllerShowing

setprop movie_ControllerShowing boolean
   put the movie_View of the target into movieView
   put the movie_Player of movieView into moviePlayer
   put the movie_Controller of movieView into movieController
   
   if exists(movieController) then
      set the visible of movieController to not boolean
      -- set the showcontroller of moviePlayer to boolean
      set the alwaysbuffer of moviePlayer to not boolean
   else
      put the qt_ScrollBarWidth of moviePlayer into qtScrollBarWidth
      put the rect of movieView into movieRect
      put the rect of moviePlayer into playerRect
      
      if movieRect = playerRect then
         if boolean is true then
            add qtScrollBarWidth to item 4 of movieRect
         else
            subtract qtScrollBarWidth from item 4 of movieRect
         end if
      end if
      
      lock screen
      set the showcontroller of moviePlayer to boolean
      set the alwaysbuffer of moviePlayer to not boolean
      set the view_Rect of movieView to movieRect
      unlock screen
   end if
end movie_ControllerShowing


--> Movie | Time
-
getprop movie_Seconds
   put the movie_Player of the target into moviePlayer
   
   put the timescale of moviePlayer into someScale
   if someScale = 0 then return empty
   put the currenttime of moviePlayer / someScale into movieSeconds
   return movieSeconds
end movie_Seconds

setprop movie_Seconds movieSeconds
   put the movie_Player of the target into moviePlayer
   
   switch movieSeconds
      case "end"
         put the duration of moviePlayer into movieTime
         set the currenttime of moviePlayer to movieTime
         break
      case "start"
         set the currenttime of moviePlayer to 0
         break
      default
         put the timescale of moviePlayer into someScale
         put round (movieSeconds * someScale) into movieTime
         set the currenttime of moviePlayer to movieTime
   end switch
   focus on moviePlayer
end movie_Seconds

getprop movie_Time
   put the movie_Player of the target into moviePlayer
   if exists(moviePlayer) is false then return empty
   
   put the currenttime of moviePlayer into cTime
   return cTime
end movie_Time

setprop movie_Time cTime
   put the movie_Player of the target into moviePlayer
   if exists(moviePlayer) is false then return empty
   
   if movieTime is "end" then
      put the duration of moviePlayer into movieEndTime
      set the currenttime of moviePlayer to movieEndTime
   else if cTime is among the items of "start,beginning" then
      set the currenttime of moviePlayer to 0
   else
      set the currenttime of moviePlayer to cTime
   end if
   focus on moviePlayer
end movie_Time

getprop movie_HMSF
   put the movie_Player of the target into moviePlayer
   
   put the timescale of moviePlayer into someScale
   if someScale = 0 then return empty
   put the currenttime of moviePlayer / someScale into movieSeconds
   return time_SecondsToHMSF(movieSeconds)
end movie_HMSF

setprop movie_HMSF hmsf
   set the movie_Seconds of the target to hmsf
end movie_HMSF

--> Clip
-
getprop clip_Duration [tFormat]
   put the movie_Player of the target into moviePlayer
   if exists(moviePlayer) is false then return empty
   
   switch tFormat
      case "raw"
         put the endtime of moviePlayer - the starttime of moviePlayer into clipDuration
         break
      case "hmsf"
      case "true"
         put the timescale of moviePlayer into someScale
         put (the endtime of moviePlayer - the starttime of moviePlayer) / someScale into dTime
         put time_SecondsToHMSF (dTime) into clipDuration
         break
      default
         -- case false
         -- case "s"
         -- case "seconds"
         put the timescale of moviePlayer into someScale
         put (the endtime of moviePlayer - the starttime of moviePlayer) / someScale into clipDuration
   end switch
   return clipDuration
end clip_Duration

getprop clip_StartTime [tFormat]
   put the movie_Player of the target into moviePlayer
   if exists(moviePlayer) is false then return empty
   
   switch tFormat
      case "raw"
         put the startTime of moviePlayer into sTime
         return sTime
      case "hmsf"
      case "true"
         put the timescale of moviePlayer into someScale
         put the starttime of moviePlayer into sTime
         put sTime / someScale into startTimeInSeconds
         put time_SecondsToHMSF (startTimeInSeconds) into startTimeInHMSF
         return startTimeInHMSF
      default
         -- case false
         -- case "s"
         -- case "seconds"
         
         put the timescale of moviePlayer into someScale
         put the starttime of moviePlayer into sTime
         put sTime / someScale into startTimeInSeconds
         return startTimeInSeconds
   end switch
end clip_StartTime

setprop clip_StartTime [tFormat] sTime
   put the movie_Player of the target into moviePlayer
   if exists(moviePlayer) is false then return empty
   
   switch tFormat
      case "raw"
         put sTime into cTime
         break
      case "true"
      case "hmsf"
         put the timescale of moviePlayer into someScale
         put time_HmsfToSeconds (sTime) into mSeconds
         put mSeconds * someScale into cTime
         break
      default
         -- case false
         -- case "s"
         -- case "seconds"
         put sTime into mSeconds
         put the timescale of moviePlayer into someScale
         put mSeconds * someScale into cTime
   end switch
   
   set the startTime of moviePlayer to cTime
   return moviePlayer
end clip_StartTime

getprop clip_EndTime [tFormat]
   put the movie_Player of the target into moviePlayer
   if exists(moviePlayer) is false then return empty
   
   switch tFormat
      case "raw"
         put the endTime of moviePlayer into eTime
         return eTime
      case "hmsf"
      case "true"
         put the timescale of moviePlayer into someScale
         put the endTime of moviePlayer / someScale into movieSeconds
         put time_SecondsToHMSF (movieSeconds) into endTimeInHMSF
         return endTimeInHMSF
      default
         -- case false
         -- case "s"
         -- case "seconds"
         put the timescale of moviePlayer into someScale
         put the endTime of moviePlayer into eTime
         put eTime / someScale into endTimeInSeconds
         return endTimeInSeconds
   end switch
end clip_EndTime

setprop clip_EndTime [tFormat] eTime
   put the movie_Player of the target into moviePlayer
   if exists(moviePlayer) is false then return empty
   
   switch tFormat
      case "raw"
         put eTime into cTime
         break
      case "true"
      case "hmsf"
         put the timescale of moviePlayer into someScale
         put time_HmsfToSeconds (eTime) into mSeconds
         put mSeconds * someScale into cTime
         break
         -- case false
         -- case "s"
         -- case "seconds"
      default
         put eTime into mSeconds
         put the timescale of moviePlayer into someScale
         put mSeconds * someScale into cTime
   end switch
   
   set the endTime of moviePlayer to cTime
   return moviePlayer
end clip_EndTime


--> Events
-
/*
on mouseDown
   trigger_Event the params
   pass mouseDown
end mouseDown

on mouseUp
   trigger_Event the params
   pass mouseUp
end mouseUp

on mouseDoubleUp
   trigger_Event the params
   pass mouseDoubleUp
end mouseDoubleUp

on mouseRelease
   trigger_Event the params
   pass mouseRelease
end mouseRelease

on playStarted
   set the movie_DisplayPaused of me to false
end playStarted

on playStopped
   set the movie_DisplayPaused of me to true
end playStopped

on playPaused
   /*
   Bug in that set the paused of player to true does not generate message while false is
   Need to manually set in any controllers and not rely on this message being sent!
   */
   set the movie_DisplayPaused of me to true
end playPaused
*/


--> Events | Drag
-
on keyDown kName
   switch kName
      case "i"
         put the movie_Seconds of me into mSeconds
         set the clip_StartTime of me to mSeconds
         break
      case "o"
         put the movie_Seconds of me into mSeconds
         set the clip_EndTime of me to mSeconds
         break
      default
         pass keyDown
   end switch
end keyDown

on dragEnter
   -- if the drag_Controller of me is not empty then
   set the acceptdrop to true
   -- end if
   pass dragEnter
end dragEnter

on dragDrop
   put the dragdata ["files"] into someFile
   if file_IsVideo (someFile) then
      set the movie_File of me to someFile
      set the movie_Paused of me to false
   end if
   
   put the dragdata ["text"] into droppedText
   if word 1 of droppedText is "opnDrop" then
      put the dragsource into targetObject
      put the view_Object of targetObject into someView
      if exists(someView) then
         if the view_IsClass ["View|Movie|Controller"] of someView is true then
            lcw_Notify "True"
         else
            lcw_Notify merge("Source [[the name of targetOject]] is not a movie controller!"), true
         end if
      else
         lcw_Notify merge("Error: source [[the name of targetOject]] is not within a view!"), true
      end if 
   else
      -- lcw_Notify (droppedText & CR & CR & the dragsource)
   end if
   pass dragDrop
end dragDrop


--> Events | Handlers
-
on movie_MouseDown movieView
   menu_PopUp
end movie_MouseDown

on movie_MouseUp
   -- do nothing
end movie_MouseUp

on movie_MouseDoubleUp
   -- do nothing
end movie_MouseDoubleUp

on movie_MouseRelease
   -- do nothing
end movie_MouseRelease


--> Objects
-
getprop movie_View
   return the long id of me
end movie_View

getprop view_Object
   return the long id of me
end view_Object

-- getprop model_Object
-- for bookmarks?
return the long id of me
end model_Object

getprop movie_Player
   return the long id of player 1 of me
end movie_Player

getprop menu_Button
return the long id of button "_Menu Button" of me
end menu_Button
 
getprop view_Background
    return the long id of control "_View Background" of me
end view_Background


--> Object | Links
-
getprop metadata_View
    put "View|Movie|Note" into viewPath
    return view_GetTemplateObject (viewPath)
end metadata_View

-- getprop movieController_View
    return the view_TwoWayLink ["movie_Paused"] of me
end movieController_View

-- setprop movieController_View [addView] movieControllerRefs
    if addView is true then
        set the view_AddTwoWayPropertyLink ["movie_Paused"] of me to movieControllerRefs
    else
        set the view_TwoWayPropertyLink ["movie_Paused"] of me to movieControllerRefs
    end if
end movieController_View


--> Geometry
-
on resizeControl
    LayoutControl the rect of me
    pass resizeControl
end resizeControl

setprop view_Rect someRect
   -- here to force a redraw when rect has not changed
   LayoutControl
end view_Rect

on LayoutControl pRect
   if pRect is empty then put the rect of me into pRect
   put the movie_Player of me into moviePlayer
   put the menu_Button of me into mButton
   put the view_Background of me into backgroundObject
   
   lock screen
   put the inner_Rect [pRect] of me into backgroundObjectRect
   put the media_Rect [backgroundObjectRect] of moviePlayer into movieRect
   if movieRect is empty then
      -- in case library is not in use
      put backgroundObjectRect into movieRect
   end if
   
   set the rect of me to pRect
   set the rect of moviePlayer to movieRect
   set the rect of backgroundObject to backgroundObjectRect
   set the rect of mButton to movieRect
   unlock screen
   
   focus on moviePlayer
   set the uOPN ["movie_Size"] of me to "resize"
end LayoutControl


--> Deps
-
function file_IsVideo someFile, quickSearch, beAggressive
   set the itemdelimiter to "."
   if the platform = "MacOS" then
      put "file -I" && kwote (someFile) into someShell
      put shell (someShell) into shellReply
      set the itemdelimiter to ":"
      get token 1 of item 2 of shellReply
      
      -- put spotlight_GetFileKind (someFile) into fileKind
      if it is "video" then
         return true
      else
         return false
      end if
   else if item -1 of someFile is among the items of "mov.mp4.avi.mpg.m4v" then
      return true
   else
      return false
   end if
end file_IsVideo
