script "Global_Movie_Menu"
--> MetaData
-
license: GPLv3
name: Global_Movie_Menu
type: controller
version: 0.2


--> Menu | Props
-
local LocalArray

on mDouble_Up indexView, someLine
   put the long id of grp 1 of stack "View|Movie" into mPlayer
   --
   edl_DeconstructLine someLine, editNum, realName, trackType, transitionType, sourceInPoint, sourceOutPoint, recorderInPoint, recorderOutPoint   
   switch transitionType
      case "C"
         -- cut
         set the itemdelimiter to ":"
         put "00" into item 1 of sourceInPoint
         put "00" into item 1 of sourceOutPoint
         --
         put time_HmsfToSeconds (sourceInPoint, 30) into inSeconds
         put time_HmsfToSeconds (sourceOutPoint, 30) into outSeconds
         --
         lock screen
         set the movie_Seconds of mPlayer to inSeconds
         set the clip_StartTime of mPlayer to inSeconds
         set the clip_EndTime of mPlayer to outSeconds
         unlock screen
         if the shiftKey is "Down" then
            set the movie_PlaySelection of mPlayer to true
            set the movie_Paused of mPlayer to false
         else
            set the movie_PlaySelection of mPlayer to false
         end if
         break
      default
         get sourceInPoint,sourceOutPoint,recorderInPoint,recorderOutPoint
         replace comma with CR in it
         put it
   end switch
end mDouble_Up 

command edl_ExportClip someVideoFile, sSeconds, eSeconds, pExportFilePath
   if pExportFilePath = "ask" then
      set the itemdelimiter to slash
      put someVideoFile into pExportFilePath
      put item -1 of pExportFilePath into shortExportFile
      put lcw_Ask ("What would you like to call the exported clip?", shortExportFile) into shortExportFile
      put shortExportFile into item -1 of pExportFilePath
   end if
   
   ffmpeg_SplitVideo someVideoFile, sSeconds, eSeconds, pExportFilePath, cutFast
   put the result into exportedVideoPath
   
   display_Video exportedVideoPath
   -- set the filename of playerObject to exportedVideoPath
   return exportedVideoPath
end edl_ExportClip

private command _SelectedClipHMSF indexView, @sourceInPoint, @sourceOutPoint
   put the selected_Line of indexView into someLine
   edl_DeconstructLine someLine, editNum, realName, trackType, transitionType, sourceInPoint, sourceOutPoint, recorderInPoint, recorderOutPoint   
end _SelectedClipHMSF

private command _SelectedClipSeconds indexView, @inSeconds, @outSeconds
   _SelectedClipHMSF indexView, sourceInPoint, sourceOutPoint
   put edl_ConvertToMovieSeconds (sourceInPoint) into inSeconds
   
   -- take one frame off out point
   put edl_ConvertToMovieSeconds (sourceOutPoint, -1) into outSeconds
end _SelectedClipSeconds

private function edl_ConvertToMovieSeconds hmsfTimeWithHourStart, pAddFrames, pFPS
   if pFPS is empty then put 30 into pFPS
   set the itemdelimiter to ":"
   put "00" into item 1 of hmsfTimeWithHourStart
   --
   put item -1 of hmsfTimeWithHourStart + pAddFrames into newFrames
   put newFrames into item -1 of hmsfTimeWithHourStart
   --
   put time_HmsfToSeconds (hmsfTimeWithHourStart, pFPS) into movieSeconds
   return movieSeconds
end edl_ConvertToMovieSeconds

function edl_ParseLines someEDL
   put line 1 of someEDL into titleLine
   put line 2 of someEDL into dropLine
   delete line 1 to 2 of someEDL
   repeat for each line someLine in someEDL
      if someLine is empty then next repeat
      
      edl_DeconstructLine someLine, editNum, realName, trackType, transitionType, sourceInPoint, sourceOutPoint, recorderInPoint, recorderOutPoint
   end repeat
   return edlArray
end edl_ParseLines

command edl_DeconstructLine someLine, @editNum, @realName, @trackType, @transitionType, @sourceInPoint, @sourceOutPoint, @recorderInPoint, @recorderOutPoint
   put word 1 of someLine into editNum
   put word 2 of someLine into realName
   put word 3 of someLine into trackType
   put word 4 of someLine into transitionType
   put word 5 of someLine into sourceInPoint
   put word 6 of someLine into sourceOutPoint
   put word 7 of someLine into recorderInPoint
   put word 8 of someLine into recorderOutPoint
end edl_DeconstructLine


--> Global | EDL | Line | Menu
-
on menu_Seek indexView, seekWhere
   put the long id of grp 1 of stack "View|Movie" into mPlayer
   _SelectedClipHMSF indexView, sourceInPoint, sourceOutPoint
   switch seekWhere
      case "Start"
         put edl_ConvertToMovieSeconds (sourceInPoint) into mSeconds
         break
      case "End"
         put edl_ConvertToMovieSeconds (sourceOutPoint) into mSeconds
         break
      case "-"
      case "Frame before start"
         put edl_ConvertToMovieSeconds (sourceInPoint, -1) into mSeconds
         break
      case "Frame before end"
         put edl_ConvertToMovieSeconds (sourceOutPoint, -1) into mSeconds
         break
   end switch
   set the movie_Seconds of mPlayer to mSeconds         
end menu_Seek

on menu_ExportClip indexView, cutFast
   put the long id of grp 1 of stack "View|Movie" into mPlayer
   --   
   _SelectedClipSeconds indexView, inSeconds, outSeconds
   put the movie_File of mPlayer into someVideoFile
   edl_ExportClip someVideoFile, inSeconds, outSeconds, "ask"
   put the result into exportedVideoPath
   -- put exportedVideoPath
end menu_ExportClip


--> Global | Movie | Menu
-
on menu_PlayMovie mPlayer
   put the movie_Player of mPlayer into pObject
   put the movie_File of mPlayer into mFile
   mplayer_Play mFile
   -- put the result
end menu_PlayMovie

on menu_ExportSelectedClip mPlayer, cutFast
   put the clip_StartTime [s] of mPlayer into sSeconds
   put the clip_EndTime [s] of mPlayer into eSeconds
   put the movie_File of mPlayer into someVideoFile
   edl_ExportClip someVideoFile, sSeconds, eSeconds, pExportFilePath
   put the result into exportedVideoPath
   put exportedVideoPath
end menu_ExportSelectedClip

on menu_DisplayEditMarkers
   put LocalArray ["someFile"] into someFile
   if someFile is empty or the shiftKey is "Down" then
      answer file "Select an EDL"
      put it into someFile
      if someFile is empty then exit to top
      put someFile into LocalArray ["someFile"]
   end if
   
   put url ("file:" & someFile) into someEDL
   replace (CR & CR) with CR in someEDL
   put line 1 of someEDL into titleLine
   put line 2 of someEDL into dropLine
   
   put word 1 to -1 of line 3 to -1 of someEDL into edlLines
   
   set the itemdelimiter to slash
   put item -1 of someFile into stackLabel
   display_Lines edlLines, "EDL", "mDouble_Up", stackLabel
   put the result into indexView
   set the line_Menu of indexView to "Global | EDL | Line | Menu"
end menu_DisplayEditMarkers
   
on _
end _

on menu_ShowController mView, someBoolean
   set the movie_ControllerShowing of mView to someBoolean
end menu_ShowController

on menu_HiliteSelection mView, someBoolean
   set the movie_ShowSelection of mView to someBoolean
end menu_HiliteSelection

on _
end _

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Global | Movie | Menu | Props
-
getprop hilite_Selection [mView]
   put the movie_ShowSelection of mView into someBoolean
   return someBoolean
end hilite_Selection

getprop show_Controller [mView]
   put the movie_ControllerShowing of mView into someBoolean
   return someBoolean
end show_Controller

getprop cut_Fasts
   return "true,false"
end cut_Fasts

--> Global | Movie | Menu | Disabled
-

--> Dev | Menu
-
on menu_DisplayMovie mTarget
   answer file "Select a movie file..." -- with type "MPEG-4 movie"
   put it into someFile
   
   put file_IsVideo (someFile)
   
   /*
   put "file -I" && kwote (someFile) into someShell
   put shell (someShell) into shellReply
   -- /Users/BabyBlue/Movies/Guerrilla.mp4: video/mp4; charset=binary
   set the itemdelimiter to ":"
   put word 1 of item 2 of shellReply ="video" into isVideo
   */
   
   put spotlight_GetFileKind (someFile) into fileKind
   -- MPEG-4 movie
   put fileKind & CR & CR & spotlight_GetFileInfo (someFile)
end menu_DisplayMovie



--> END

on insert_MoviePlayerMenu
    return "Global | Movie | Video | Menu"
end insert_MoviePlayerMenu

on _
end _

on submenu_Capture
   return "Global | Movie | Capture | Menu"
end submenu_Capture

on submenu_RecordMovie
   return "Global | Movie | Record | Menu"
end submenu_RecordMovie

on submenu_BookMarkMenu
   return "Global | Movie | Bookmarks | Menu", subMenu
end submenu_BookMarkMenu

on submenu_MovieCallMenu
    menu_DoSub "Global | Movie | Call | Menu"
end submenu_MovieCallMenu
    
on submenu_QuickTime
    return "Global | QuickTime | Menu"
end submenu_QuickTime

on submenu_MovieTools
    return "Movie | Tools | Menu"
end submenu_MovieTools

on submenu_MovieWindowMenu
    return "Global | Movie | Window | Menu"
end submenu_MovieWindowMenu
